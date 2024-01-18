# ----------------------------------------------------------------------------------------------
# Null Resource
# ----------------------------------------------------------------------------------------------
resource "null_resource" "install_dependencies" {

  provisioner "local-exec" {
    command = <<EOT
cd ./src/ocpp-message-processor &&
sudo pip install -r requirements.txt -t /asset-output && sudo cp -au . /asset-output
EOT
  }
}

# ----------------------------------------------------------------------------------------------
# Archive File - Message Processor
# ----------------------------------------------------------------------------------------------
data "archive_file" "msg_processor" {
  depends_on  = [null_resource.install_dependencies]
  type        = "zip"
  source_dir  = "/asset-output"
  output_path = "./dist/ocpp-message-processor.zip"
}

# ----------------------------------------------------------------------------------------------
# AWS Lambda Function - Message Processor
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "msg_processor" {
  function_name    = "${var.prefix}_OCPPMessageProcessor"
  handler          = "message_processor.lambda_handler"
  memory_size      = 128
  package_type     = "Zip"
  role             = var.lambda_role_arn_message_processor
  runtime          = "python3.9"
  filename         = data.archive_file.msg_processor.output_path
  source_code_hash = data.archive_file.msg_processor.output_base64sha256
}

# ----------------------------------------------------------------------------------------------
# AWS Lambda Event Source Mapping - Message Processor
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_event_source_mapping" "msg_processor" {
  event_source_arn = var.sqs_arn_incoming_message
  function_name    = aws_lambda_function.msg_processor.function_name
}

# ----------------------------------------------------------------------------------------------
# Archive File - Delete Thing
# ----------------------------------------------------------------------------------------------
data "archive_file" "delete_thing" {
  type        = "zip"
  source_dir  = "./src/iot-rule-delete-thing"
  output_path = "./dist/iot-rule-delete-thing.zip"
}

# ----------------------------------------------------------------------------------------------
# AWS Lambda Function - Delete Thing
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "delete_thing" {
  function_name    = "${var.prefix}_DeleteThing"
  handler          = "delete_thing.lambda_handler"
  memory_size      = 128
  package_type     = "Zip"
  role             = var.lambda_role_arn_delete_thing
  runtime          = "python3.9"
  timeout          = 30
  filename         = data.archive_file.delete_thing.output_path
  source_code_hash = data.archive_file.delete_thing.output_base64sha256

  environment {
    variables = {
      DYNAMODB_CHARGE_POINT_TABLE = var.dynamodb_table_charge_point
    }
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Lambda Event Source Mapping - Delete Thing
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_event_source_mapping" "delete_thing" {
  event_source_arn = var.sqs_arn_delete_thing
  function_name    = aws_lambda_function.delete_thing.function_name
}
