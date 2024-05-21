# ----------------------------------------------------------------------------------------------
# AWS S3 Bucket
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "this" {
  bucket = "${local.prefix}-configs-20240518"
}

# ----------------------------------------------------------------------------------------------
# AWS S3 Bucket ACL - Private
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS S3 Bucket ACL - Private
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket_acl" "this" {
  depends_on = [aws_s3_bucket_ownership_controls.this]

  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

# ----------------------------------------------------------------------------------------------
# AWS S3 Bucket Versioning - Enabled
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS S3 Bucket Notification - Enabled
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket_notification" "this" {
  bucket      = aws_s3_bucket.this.id
  eventbridge = true
}

# ----------------------------------------------------------------------------------------------
# S3 Object - buildspec.yml
# ----------------------------------------------------------------------------------------------
resource "aws_s3_object" "buildspec" {
  bucket = aws_s3_bucket.this.bucket
  key    = "modules/buildspec.yml"
  source = "${path.module}/files/buildspec.yml"
  etag   = filemd5("${path.module}/files/buildspec.yml")
}

# ----------------------------------------------------------------------------------------------
# S3 Object - package.json
# ----------------------------------------------------------------------------------------------
resource "aws_s3_object" "package_json" {
  bucket = aws_s3_bucket.this.bucket
  key    = "modules/package.json"
  source = "${path.module}/files/package.json"
  etag   = filemd5("${path.module}/files/package.json")
}
