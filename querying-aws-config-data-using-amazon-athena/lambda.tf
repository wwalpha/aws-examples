# ----------------------------------------------------------------------------------------------
# Lambda Function
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "this" {
  function_name    = "${var.prefix}-bucket-events"
  filename         = data.archive_file.lambda_default.output_path
  source_code_hash = data.archive_file.lambda_default.output_base64sha256
  handler          = "index.lambda_handler"
  memory_size      = 256
  role             = aws_iam_role.lambda_bucket_event.arn
  runtime          = "python3.12"
  timeout          = 60
}

# ----------------------------------------------------------------------------------------------
# Lambda Function Permission
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_permission" "bucket_event" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.snapshots.arn
}

# ----------------------------------------------------------------------------------------------
# Archive file - Lambda default module
# ----------------------------------------------------------------------------------------------
data "archive_file" "lambda_default" {
  type        = "zip"
  output_path = "${path.module}/dist/default.zip"

  source {
    content  = <<EOT
import datetime
import re
import boto3
import os

TABLE_NAME = '${aws_glue_catalog_table.config_snapshots.name}'
DATABASE_NAME = '${aws_glue_catalog_database.this.name}'
ACCOUNT_ID = None # Determined at runtime
LATEST_PARTITION_VALUE = 'latest'

athena = boto3.client('athena')

def lambda_handler(event, context):
    global ACCOUNT_ID
    
    print(event)

    object_key = event['Records'][0]['s3']['object']['key']
    match = get_configuration_snapshot_object_key_match(object_key)
    if match is None:
        print('Ignoring event for non-configuration snapshot object key', object_key)
        return
    print('Adding partitions for configuration snapshot object key', object_key)
    
    ACCOUNT_ID = context.invoked_function_arn.split(':')[4]
    object_key_parent = 's3://{bucket_name}/{object_key_parent}/'.format(
        bucket_name=event['Records'][0]['s3']['bucket']['name'],
        object_key_parent=os.path.dirname(object_key))
    configuration_snapshot_accountid = get_configuration_snapshot_accountid(match)
    configuration_snapshot_region = get_configuration_snapshot_region(match)
    configuration_snapshot_date = get_configuration_snapshot_date(match)
    
    drop_partition(configuration_snapshot_accountid, configuration_snapshot_region, LATEST_PARTITION_VALUE)
    add_partition(configuration_snapshot_accountid, configuration_snapshot_region, LATEST_PARTITION_VALUE, object_key_parent)
    add_partition(configuration_snapshot_accountid, configuration_snapshot_region, get_configuration_snapshot_date(match).strftime('%Y-%m-%d'), object_key_parent)
    
def get_configuration_snapshot_object_key_match(object_key):
    # Matches object keys like AWSLogs/123456789012/Config/us-east-1/2018/4/11/ConfigSnapshot/123456789012_Config_us-east-1_ConfigSnapshot_20180411T054711Z_a970aeff-cb3d-4c4e-806b-88fa14702hdb.json.gz
    return re.match('AWSLogs/(\d+)/Config/([\w-]+)/(\d+)/(\d+)/(\d+)/ConfigSnapshot/[^\\\]+$', object_key)

def get_configuration_snapshot_accountid(match):
    print('AccountId:', match.group(1))
    return match.group(1)

def get_configuration_snapshot_region(match):
    return match.group(2)

def get_configuration_snapshot_date(match):
    return datetime.date(int(match.group(3)), int(match.group(4)), int(match.group(5)))
    
def add_partition(accountid_partition_value, region_partition_value, dt_partition_value, partition_location):
    execute_query('ALTER TABLE {table_name} ADD PARTITION {partition} location \'{partition_location}\''.format(
        table_name=TABLE_NAME,
        partition=build_partition_string(accountid_partition_value, region_partition_value, dt_partition_value),
        partition_location=partition_location))
        
def drop_partition(accountid_partition_value, region_partition_value, dt_partition_value):
    execute_query('ALTER TABLE {table_name} DROP PARTITION {partition}'.format(
        table_name=TABLE_NAME,
        partition=build_partition_string(accountid_partition_value, region_partition_value, dt_partition_value)))
        
def build_partition_string(accountid_partition_value, region_partition_value, dt_partition_value):
    return "(accountid='{accountid_partition_value}', dt='{dt_partition_value}', region='{region_partition_value}')".format(
	    accountid_partition_value=accountid_partition_value,
        dt_partition_value=dt_partition_value,
        region_partition_value=region_partition_value)

def execute_query(query):
    print('Executing query:', query)
    query_output_location = 's3://aws-athena-query-results-334678299258-ap-northeast-1/'

    start_query_response = athena.start_query_execution(
        QueryString=query,
        QueryExecutionContext={
            'Database': DATABASE_NAME
        },
        ResultConfiguration={
            'OutputLocation': query_output_location,
        }
    )

    print('Query started')

    is_query_running = True
    while is_query_running:
        get_query_execution_response = athena.get_query_execution(
            QueryExecutionId=start_query_response['QueryExecutionId']
        )
        query_state = get_query_execution_response['QueryExecution']['Status']['State']
        is_query_running = query_state in ('RUNNING','QUEUED')
        
        # print('is_query_running:', is_query_running, query_state)
        
        if not is_query_running and query_state != 'SUCCEEDED':
            raise Exception('Query failed')
    print('Query completed')
EOT
    filename = "index.py"
  }
}
