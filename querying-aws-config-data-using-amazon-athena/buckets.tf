# ----------------------------------------------------------------------------------------------
# AWS S3 Bucket - AWS Config Snapshots
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "snapshots" {
  bucket        = local.s3_bucket_config_snapshots
  force_destroy = true
}

# ----------------------------------------------------------------------------------------------
# AWS S3 Bucket Policy - Allow Access from AWS Config Service
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket_policy" "allow_access_from_config_service" {
  bucket = aws_s3_bucket.snapshots.id
  policy = data.aws_iam_policy_document.allow_access_from_config_service.json
}

data "aws_iam_policy_document" "allow_access_from_config_service" {
  statement {
    sid    = "AWSConfigBucketPermissionsCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      aws_s3_bucket.snapshots.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"
      values   = [local.account_id]
    }
  }

  statement {
    sid    = "AWSConfigBucketExistenceCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.snapshots.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"
      values   = [local.account_id]
    }
  }

  statement {
    sid    = "AWSConfigBucketDelivery"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = ["${aws_s3_bucket.snapshots.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"
      values   = [local.account_id]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

# ----------------------------------------------------------------------------------------------
# AWS S3 Bucket Notification
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket_notification" "this" {
  depends_on = [aws_lambda_function.this]
  bucket     = aws_s3_bucket.snapshots.id

  lambda_function {
    events              = ["s3:ObjectCreated:*"]
    lambda_function_arn = aws_lambda_function.this.arn
  }
}
