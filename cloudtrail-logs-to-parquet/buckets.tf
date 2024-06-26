# ----------------------------------------------------------------------------------------------
# AWS S3 Bucket - ETL Job Script
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "etl_job_script" {
  bucket = local.s3_bucket_etl_scripts
}

# ----------------------------------------------------------------------------------------------
# AWS S3 Object - ETL Job Script
# ----------------------------------------------------------------------------------------------
resource "aws_s3_object" "etl_job_script" {
  bucket = aws_s3_bucket.etl_job_script.id
  key    = "glue_etl.py"
  source = "${path.module}/scripts/glue_etl.py"
}

# ----------------------------------------------------------------------------------------------
# AWS S3 Bucket - Glue temp
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "glue_temp" {
  bucket = local.s3_bucket_glue_temp
}
