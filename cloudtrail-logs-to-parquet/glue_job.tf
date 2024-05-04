# ----------------------------------------------------------------------------------------------
# AWS Glue Job - Cloudtrail JSON to Parquet
# ----------------------------------------------------------------------------------------------
resource "aws_glue_job" "cloudtrail_to_parquet" {
  name              = "CloudTrailToParquet${local.suffix}"
  role_arn          = aws_iam_role.cloudtrail_parquet_glue.arn
  glue_version      = "4.0"
  worker_type       = "G.1X"
  number_of_workers = 2
  execution_class   = "STANDARD"

  command {
    script_location = "s3://${local.s3_bucket_etl_scripts}/glue_etl.py"
  }

  default_arguments = {
    "--TempDir" = "s3://${aws_s3_bucket.glue_temp.id}"
    "--glue_database"        = "${var.glue_catalog_database}"
    "--raw_cloudtrail_table" = "raw_cloudtrail_table"
    "--results_bucket"       = "${var.s3_bucket_cloudtrail_parquet}"
    "--job-language"         = "python"
    "--enable-job-insights"  = "false"
    "--job-bookmark-option"  = "job-bookmark-enable"
  }
}
