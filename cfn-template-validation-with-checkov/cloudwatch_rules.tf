# ----------------------------------------------------------------------------------------------
# AWS CloudWatch Event Rule
# ----------------------------------------------------------------------------------------------
resource "aws_cloudwatch_event_rule" "this" {
  name = "${local.prefix}-S3EventRule"

  event_pattern = jsonencode({
    source = [
      "aws.s3"
    ]
    detail-type = [
      "Object Created"
    ]
    detail = {
      bucket = {
        name = [
          "${aws_s3_bucket.this.bucket}"
        ]
      }
      object = {
        key = [
          {
            wildcard = "*.yml"
          }
        ]
      }
    }
  })
}

# ----------------------------------------------------------------------------------------------
# AWS CloudWatch Event Target
# ----------------------------------------------------------------------------------------------
resource "aws_cloudwatch_event_target" "this" {
  rule     = aws_cloudwatch_event_rule.this.name
  arn      = aws_sfn_state_machine.this.arn
  role_arn = aws_iam_role.events.arn

  input_transformer {
    input_paths = {
      "key"    = "$.detail.object.key"
      "bucket" = "$.detail.bucket.name"
    }
    input_template = <<EOT
{
  "key": <key>,
  "bucket": <bucket>
}
EOT
  }
}
