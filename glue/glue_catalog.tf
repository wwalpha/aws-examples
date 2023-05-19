# ----------------------------------------------------------------------------------------------
# AWS Glue Catalog Encryption Settings
# ----------------------------------------------------------------------------------------------
resource "aws_glue_data_catalog_encryption_settings" "this" {
  data_catalog_encryption_settings {
    connection_password_encryption {
      aws_kms_key_id                       = "arn:aws:kms:ap-northeast-1:334678299258:key/296fbd64-a88d-4d11-9931-724383fedaeb"
      return_connection_password_encrypted = true
    }

    encryption_at_rest {
      catalog_encryption_mode = "SSE-KMS"
      sse_aws_kms_key_id      = "arn:aws:kms:ap-northeast-1:334678299258:key/296fbd64-a88d-4d11-9931-724383fedaeb"
    }
  }
}

# ----------------------------------------------------------------------------------------------
# Glue Catalog Database - Raw Database
# ----------------------------------------------------------------------------------------------
resource "aws_glue_catalog_database" "raw" {
  name = "glue-raw-db"
}

# ----------------------------------------------------------------------------------------------
# Glue Catalog Database - Refined Database
# ----------------------------------------------------------------------------------------------
resource "aws_glue_catalog_database" "refined" {
  name = "glue-refined-db"
}


# ----------------------------------------------------------------------------------------------
# AWS Glue Job - Raw ETL
# ----------------------------------------------------------------------------------------------
resource "aws_glue_job" "raw_etl" {
  name     = "glue-raw-etl-job"
  role_arn = aws_iam_role.raw_etl_job.arn

  default_arguments = {
    "--TempDir"                          = "s3://aws-glue-assets-334678299258-ap-northeast-1/temporary/"
    "--enable-job-insights"              = "true"
    "--job-bookmark-option"              = "job-bookmark-enable"
    "--job-language"                     = "python"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-glue-datacatalog"          = "true"
    "--enable-metrics"                   = "true"
    "--enable-spark-ui"                  = "true"
    "--spark-event-logs-path"            = "s3://aws-glue-assets-334678299258-ap-northeast-1/sparkHistoryLogs/"
  }

  glue_version      = "4.0"
  execution_class   = "STANDARD"
  number_of_workers = 2
  worker_type       = "G.1X"

  command {
    python_version  = "3"
    script_location = "s3://pkc-uploads-376965/scripts/test001.py"
  }

  execution_property {
    max_concurrent_runs = 1
  }
}
