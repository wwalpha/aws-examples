# ----------------------------------------------------------------------------------------------
# AWS Step Function State Machine - Validation
# ----------------------------------------------------------------------------------------------
resource "aws_sfn_state_machine" "this" {
  name     = "${local.prefix}-templates"
  role_arn = aws_iam_role.sfn.arn

  definition = <<EOF
{
  "Comment": "CloudFormation template validation process.",
  "StartAt": "StartBuild",
  "States": {
    "StartBuild": {
      "Type": "Task",
      "Resource": "arn:aws:states:::codebuild:startBuild.sync",
      "Parameters": {
        "ProjectName": "${aws_codebuild_project.this.name}",
        "EnvironmentVariablesOverride": [
          {
            "Name": "OBJECT_KEY",
            "Value.$": "$.key",
            "Type": "PLAINTEXT"
          },
          {
            "Name": "BUCKET_NAME",
            "Value.$": "$.bucket",
            "Type": "PLAINTEXT"
          }
        ]
      },
      "Next": "GetBuildResult"
    },
    "GetBuildResult": {
      "Type": "Task",
      "Resource": "arn:aws:states:::aws-sdk:codebuild:batchGetBuilds",
      "Parameters": {
        "Ids.$": "States.Array($.Build.Id)"
      },
      "Next": "CheckResults"
    },
    "CheckResults": {
      "Type": "Choice",
      "Choices": [
        {
          "And": [
            {
              "Variable": "$.Builds[0].BuildStatus",
              "StringEquals": "SUCCEEDED"
            }
          ],
          "Next": "Notify Success"
        }
      ],
      "Default": "Notify Failure"
    },
    "Notify Success": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Subject": "CloudFormation template validation succeeded",
        "Message.$": "States.Format('File: {}', $.key)",
        "TopicArn": "${aws_sns_topic.nofity.arn}"
      },
      "End": true
    },
    "Notify Failure": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Subject": "CloudFormation template validation failure",
        "Message.$": "States.Format('File: {}', $.key)",
        "TopicArn": "${aws_sns_topic.nofity.arn}"
      },
      "End": true
    }
  },
  "TimeoutSeconds": 3600
}
EOF

  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.sfn.arn}:*"
    include_execution_data = true
    level                  = "ERROR"
  }

  # lifecycle {
  #   ignore_changes = [definition]
  # }
}
