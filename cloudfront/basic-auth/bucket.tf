# ----------------------------------------------------------------------------------------------
# AWS S3 Bucket
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "this" {
  bucket = "${local.prefix}-app-20240802-${local.region}"
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
# Amazon S3 Bucket Policy
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = aws_s3_bucket.this.bucket
  policy = data.aws_iam_policy_document.allow_access_from_cloudfront.json
}

# ----------------------------------------------------------------------------------------------
# AWS IAM Policy
# ----------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "allow_access_from_cloudfront" {
  depends_on = [aws_cloudfront_origin_access_control.this]

  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.this.bucket}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.this.arn]
    }
  }
}

# ----------------------------------------------------------------------------------------------
# File Upload
# ----------------------------------------------------------------------------------------------
resource "aws_s3_object" "this" {
  for_each     = fileset("app/", "**/*.*")
  bucket       = aws_s3_bucket.this.bucket
  key          = each.value
  source       = "app/${each.value}"
  etag         = filemd5("app/${each.value}")
  content_type = lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])

  lifecycle {
    ignore_changes = [
      etag
    ]
  }
}
