# ----------------------------------------------------------------------------------------------
# AWS Step Function State Machine
# ----------------------------------------------------------------------------------------------
resource "aws_sfn_state_machine" "this" {
  name     = "${local.prefix}-agent-config-distrubute"
  role_arn = aws_iam_role.sfn.arn

  definition = <<EOF
{
  "Comment": "CloudWatch Agent config auto convert and validation process",
  "StartAt": "Validation Start",
  "States": {
    "Validation Start": {
      "Type": "Task",
      "Resource": "arn:aws:states:::aws-sdk:sns:publish",
      "Parameters": {
        "TopicArn": "${aws_sns_topic.nofity.arn}",
        "Subject": "CloudWatch Agent Config Validation Start",
        "Message": "test\n12123123"
      },
      "Next": "StartBuild",
      "ResultPath": null
    },
    "StartBuild": {
      "Type": "Task",
      "Resource": "arn:aws:states:::codebuild:startBuild.sync",
      "Parameters": {
        "ProjectName": "monitoringBuildProject",
        "EnvironmentVariablesOverride": [
          {
            "Name": "BUCKET_NAME",
            "Type": "PLAINTEXT",
            "Value.$": "$.bucket"
          },
          {
            "Name": "OBJECT_KEY",
            "Type": "PLAINTEXT",
            "Value.$": "$.key"
          }
        ]
      },
      "Next": "BuildStatus",
      "ResultSelector": {
        "buildId.$": "$.Build.Id",
        "buildStatus.$": "$.Build.BuildStatus"
      }
    },
    "BuildStatus": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.buildStatus",
          "StringEquals": "SUCCEEDED",
          "Comment": "SUCCEEDED",
          "Next": "RequestUserApprove"
        }
      ],
      "Default": "Validation Failed"
    },
    "RequestUserApprove": {
      "Type": "Task",
      "Parameters": {
        "DocumentName": "monitoring-UserApprove",
        "Parameters": {
          "taskToken.$": "States.Array($$.Task.Token)"
        }
      },
      "Resource": "arn:aws:states:::aws-sdk:ssm:startAutomationExecution.waitForTaskToken",
      "Next": "GetObject",
      "ResultPath": null
    },
    "GetObject": {
      "Type": "Task",
      "Parameters": {
        "Bucket.$": "$.bucket",
        "Key.$": "$.key"
      },
      "Resource": "arn:aws:states:::aws-sdk:s3:getObject",
      "Next": "StartAutomationExecution"
    },
    "StartAutomationExecution": {
      "Type": "Task",
      "Next": "Validation Completed",
      "Parameters": {
        "DocumentName": "MyData"
      },
      "Resource": "arn:aws:states:::aws-sdk:ssm:startAutomationExecution.waitForTaskToken"
    },
    "Validation Completed": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Message.$": "$",
        "TopicArn": "arn:aws:sns:ap-northeast-1:334678299258:monitoring-topic"
      },
      "Next": "Success"
    },
    "Validation Failed": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Message.$": "$",
        "TopicArn": "arn:aws:sns:ap-northeast-1:334678299258:monitoring-topic"
      },
      "Next": "Fail"
    },
    "Success": {
      "Type": "Succeed"
    },
    "Fail": {
      "Type": "Fail"
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
