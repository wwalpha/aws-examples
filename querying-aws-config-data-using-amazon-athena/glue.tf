# ----------------------------------------------------------------------------------------------
# AWS Glue Catalog Database - AWS Configs
# ----------------------------------------------------------------------------------------------
resource "aws_glue_catalog_database" "this" {
  name = "${var.prefix}-db"

  create_table_default_permission {
    permissions = ["SELECT"]

    principal {
      data_lake_principal_identifier = "IAM_ALLOWED_PRINCIPALS"
    }
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Glue Catalog Table - AWS Config Snapshots
# ----------------------------------------------------------------------------------------------
resource "aws_glue_catalog_table" "config_snapshots" {
  name          = "aws_config_configuration_snapshot"
  database_name = aws_glue_catalog_database.this.name
  table_type    = "EXTERNAL_TABLE"
  retention     = 0

  partition_keys {
    name = "accountid"
    type = "string"
  }

  partition_keys {
    name = "dt"
    type = "string"
  }

  partition_keys {
    name = "region"
    type = "string"
  }

  parameters = {
    EXTERNAL                = "TRUE"
    "transient_lastDdlTime" = "1717471594"
  }

  storage_descriptor {
    location                  = "s3://${aws_s3_bucket.snapshots.bucket}/AWSLogs"
    input_format              = "org.apache.hadoop.mapred.TextInputFormat"
    output_format             = "org.apache.hadoop.hive.ql.io.IgnoreKeyTextOutputFormat"
    compressed                = false
    number_of_buckets         = -1
    stored_as_sub_directories = false

    ser_de_info {
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"

      parameters = {
        "serialization.format"                 = "1"
        "case.insensitive"                     = "false"
        "mapping.arn"                          = "ARN"
        "mapping.availabilityzone"             = "availabilityZone"
        "mapping.awsaccountid"                 = "awsAccountId"
        "mapping.awsregion"                    = "awsRegion"
        "mapping.configsnapshotid"             = "configSnapshotId"
        "mapping.configurationitemcapturetime" = "configurationItemCaptureTime"
        "mapping.configurationitems"           = "configurationItems"
        "mapping.configurationitemstatus"      = "configurationItemStatus"
        "mapping.configurationitemversion"     = "configurationItemVersion"
        "mapping.configurationstateid"         = "configurationStateId"
        "mapping.configurationstatemd5hash"    = "configurationStateMd5Hash"
        "mapping.fileversion"                  = "fileVersion"
        "mapping.resourceid"                   = "resourceId"
        "mapping.resourcename"                 = "resourceName"
        "mapping.resourcetype"                 = "resourceType"
        "mapping.supplementaryconfiguration"   = "supplementaryConfiguration"
      }
    }

    columns {
      name = "fileversion"
      type = "string"
    }

    columns {
      name = "configsnapshotid"
      type = "string"
    }

    columns {
      name = "configurationitems"
      type = "array<struct<configurationItemVersion:string,configurationItemCaptureTime:string,configurationStateId:bigint,awsAccountId:string,configurationItemStatus:string,resourceType:string,resourceId:string,resourceName:string,ARN:string,awsRegion:string,availabilityZone:string,configurationStateMd5Hash:string,configuration:string,supplementaryConfiguration:map<string,string>,tags:map<string,string>,resourceCreationTime:string>>"
    }

    # skewed_info {
    #   skewed_column_names               = []
    #   skewed_column_value_location_maps = []
    #   skewed_column_values              = []
    # }
  }
}

