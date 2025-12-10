# ----------------------------------------------------------------------------------------------
# AWS Step Function State Machine - Transform Metrics
# ----------------------------------------------------------------------------------------------
resource "aws_sfn_state_machine" "this" {
  name     = "${local.prefix}-transform-to-metrics"
  role_arn = aws_iam_role.sfn.arn

  definition = <<EOF
{
  "Comment": "A description of my state machine",
  "StartAt": "Pass",
  "States": {
    "Pass": {
      "Type": "Pass",
      "Next": "PutMetricData",
      "Parameters": {
        "region.$": "$.region",
        "sourceType.$": "$.detail.SourceType",
        "sourceIdentifier.$": "$.detail.SourceIdentifier",
        "eventID.$": "$.detail.EventID"
      }
    },
    "PutMetricData": {
      "Type": "Task",
      "Parameters": {
        "MetricData": [
          {
            "MetricName.$": "$.eventID",
            "Value": 1,
            "Unit": "Count",
            "Dimensions": [
              {
                "Name": "Type",
                "Value.$": "$.sourceType"
              },
              {
                "Name": "Identifier",
                "Value.$": "$.sourceIdentifier"
              }
            ]
          }
        ],
        "Namespace": "DEMO/RDS"
      },
      "Resource": "arn:aws:states:::aws-sdk:cloudwatch:putMetricData",
      "End": true
    }
  }
}
EOF

  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.sfn.arn}:*"
    include_execution_data = true
    level                  = "ERROR"
  }

  lifecycle {
    ignore_changes = [definition]
  }
}

