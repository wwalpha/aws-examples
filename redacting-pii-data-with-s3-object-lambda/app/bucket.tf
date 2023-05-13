# ----------------------------------------------------------------------------------------------
# Amazon S3 Object Lambda Access Point
# ----------------------------------------------------------------------------------------------
resource "aws_s3control_object_lambda_access_point" "this" {
  name = "${var.prefix}-object-lambda-ap"

  configuration {
    supporting_access_point = var.s3_access_point_arn

    transformation_configuration {
      actions = ["GetObject"]

      content_transformation {
        aws_lambda {
          function_arn = aws_lambda_function.this.arn
        }
      }
    }
  }
}

# ----------------------------------------------------------------------------------------------
# Amazon S3 Bucket Policy
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = var.s3_bucket_name
  policy = data.aws_iam_policy_document.allow_access_from_cloudfront.json
}

# ----------------------------------------------------------------------------------------------
# AWS IAM Policy
# ----------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "allow_access_from_cloudfront" {
  depends_on = [aws_cloudfront_distribution.this]

  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.this.arn]
    }
  }
}
