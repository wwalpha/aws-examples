# ----------------------------------------------------------------------------------------------
# AWS CloudWatch Event Rule
# ----------------------------------------------------------------------------------------------
resource "aws_cloudwatch_event_rule" "this" {
  name = "${local.prefix}-RDSEventRule"

  event_pattern = jsonencode({
    source = [
      "aws.rds"
    ]
    detail-type = [
      "RDS DB Instance Event",
      "RDS DB Cluster Event"
    ]
    # detail = {
    #   bucket = {
    #     name = [
    #       "${aws_s3_bucket.this.bucket}"
    #     ]
    #   }
    #   object = {
    #     key = [
    #       {
    #         wildcard = "some-prefix/*.txt"
    #       }
    #     ]
    #   }
    # }
  })
}

# ----------------------------------------------------------------------------------------------
# AWS CloudWatch Event Target
# ----------------------------------------------------------------------------------------------
resource "aws_cloudwatch_event_target" "this" {
  rule     = aws_cloudwatch_event_rule.this.name
  arn      = aws_sfn_state_machine.this.arn
  role_arn = aws_iam_role.events.arn
}
