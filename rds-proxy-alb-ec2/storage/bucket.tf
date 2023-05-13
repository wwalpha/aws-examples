resource "random_id" "this" {
  byte_length = 4
}

# ----------------------------------------------------------------------------------------------
# Amazon S3 (archive用)
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "archive" {
  bucket = "rds-proxy-${random_id.this.hex}"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.archive.id
  versioning_configuration {
    status = "Enabled"
  }
}
