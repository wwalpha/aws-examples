# ----------------------------------------------------------------------------------------------
# Amazon S3 Bucket 
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "this" {
  bucket = "${var.prefix}-${local.account_id}-pii-datas"
}

# ----------------------------------------------------------------------------------------------
# Amazon S3 Access Point 
# ----------------------------------------------------------------------------------------------
resource "aws_s3_access_point" "this" {
  bucket = aws_s3_bucket.this.id
  name   = "${var.prefix}-redacting-pii"
}

# ----------------------------------------------------------------------------------------------
# Amazon S3 Object
# ----------------------------------------------------------------------------------------------
resource "aws_s3_object" "this" {
  bucket = aws_s3_bucket.this.id
  key    = "tutorial.txt"
  source = "${path.module}/tutorial.txt"

  etag = filemd5("${path.module}/tutorial.txt")
}
