# ----------------------------------------------------------------------------------------------
# AWS S3
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "this" {
  bucket        = "lawscm-${var.env_name}"
  force_destroy = false
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [aws_s3_bucket_ownership_controls.this]

  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    bucket_key_enabled = false

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ----------------------------------------------------------------------------------------------
# AWS S3 - Security
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "security" {
  bucket        = "lawscm-${var.env_name}-security"
  force_destroy = false
}

resource "aws_s3_bucket_ownership_controls" "security" {
  bucket = aws_s3_bucket.security.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "security" {
  depends_on = [aws_s3_bucket_ownership_controls.security]

  bucket = aws_s3_bucket.security.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "security" {
  bucket = aws_s3_bucket.security.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "security" {
  bucket = aws_s3_bucket.security.id

  rule {
    bucket_key_enabled = false

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
