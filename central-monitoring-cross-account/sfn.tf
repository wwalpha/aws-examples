# ----------------------------------------------------------------------------------------------
# AWS Step Function State Machine
# ----------------------------------------------------------------------------------------------
resource "aws_sfn_state_machine" "this" {
  name     = "${local.prefix}-agent-config-distrubute"
  role_arn = aws_iam_role.sfn.arn

  definition = <<EOF
{
  "Comment": "A Hello World example of the Amazon States Language using an AWS Lambda Function",
  "StartAt": "CodeBuild StartBuild",
  "States": {
    "CodeBuild StartBuild": {
      "Type": "Task",
      "Resource": "arn:aws:states:::codebuild:startBuild.sync",
      "Parameters": {
        "ProjectName": "$.ProjectName"
      },
      "Next": "CodeBuild BatchGetReports"
    },
    "CodeBuild BatchGetReports": {
      "Type": "Task",
      "Resource": "arn:aws:states:::codebuild:batchGetReports",
      "Parameters": {
        "ReportArns.$": "$.Build.ReportArns"
      },
      "End": true
    }
  }
}
EOF

  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.sfn.arn}:*"
    include_execution_data = true
    level                  = "ALL"
  }

  lifecycle {
    ignore_changes = [definition]
  }
}
