# ----------------------------------------------------------------------------------------------
# AWS Step Function State Machine - Config PreCheck
# ----------------------------------------------------------------------------------------------
resource "aws_sfn_state_machine" "precheck" {
  name     = "${local.prefix}-agent-config-precheck"
  role_arn = aws_iam_role.sfn.arn

  definition = <<EOF
{
  "Comment": "A Hello World example of the Amazon States Language using an AWS Lambda Function",
  "StartAt": "Pass",
  "States": {
    "Pass": {
      "Type": "Pass",
      "Next": "ParameterNullChecks",
      "Parameters": {
        "accountId.$": "States.ArrayGetItem(States.StringSplit($.key, '/'), 1)",
        "os.$": "States.ArrayGetItem(States.StringSplit($.key, '/'), 2)",
        "instanceId.$": "States.ArrayGetItem(States.StringSplit($.key, '/'), 3)",
        "bucket.$": "$.bucket",
        "key.$": "$.key"
      }
    },
    "ParameterNullChecks": {
      "Type": "Choice",
      "Choices": [
        {
          "And": [
            {
              "Variable": "$.os",
              "IsPresent": true
            },
            {
              "Variable": "$.accountId",
              "IsPresent": true
            },
            {
              "Variable": "$.instanceId",
              "IsPresent": true
            }
          ],
          "Next": "ParameterOSCheck"
        }
      ],
      "Default": "ParameterNullCheckFailed"
    },
    "ParameterOSCheck": {
      "Type": "Choice",
      "Choices": [
        {
          "Or": [
            {
              "Variable": "$.os",
              "StringEquals": "linux"
            },
            {
              "Variable": "$.os",
              "StringEquals": "windows"
            }
          ],
          "Next": "DescribeInstances"
        }
      ],
      "Default": "OSCheckFailed"
    },
    "DescribeInstances": {
      "Type": "Task",
      "Next": "InstanceExistCheck",
      "Parameters": {
        "InstanceIds.$": "States.Array($.instanceId)"
      },
      "Resource": "arn:aws:states:::aws-sdk:ec2:describeInstances",
      "ResultPath": "$.results"
    },
    "InstanceExistCheck": {
      "Type": "Choice",
      "Choices": [
        {
          "And": [
            {
              "Variable": "$.results.Reservations[0]",
              "IsPresent": true
            },
            {
              "Variable": "$.results.Reservations[0].Instances[0]",
              "IsPresent": true
            }
          ],
          "Next": "Validation Start"
        }
      ],
      "Default": "InstanceExistCheckFailed"
    },
    "InstanceExistCheckFailed": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Message.$": "$",
        "TopicArn": "arn:aws:sns:ap-northeast-1:334678299258:monitoring-topic"
      },
      "Next": "PrecheckFail"
    },
    "OSCheckFailed": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Message.$": "$",
        "TopicArn": "arn:aws:sns:ap-northeast-1:334678299258:monitoring-topic"
      },
      "Next": "PrecheckFail"
    },
    "Validation Start": {
      "Type": "Task",
      "Resource": "arn:aws:states:::aws-sdk:sns:publish",
      "Parameters": {
        "TopicArn": "arn:aws:sns:ap-northeast-1:334678299258:monitoring-topic",
        "Subject": "CloudWatch Agent Config Validation Start",
        "Message.$": "States.Format('Workflow Details: https://ap-northeast-1.console.aws.amazon.com/states/home?#/v2/executions/details/{}\nTarget AWS AccountId: {}\nTarget EC2 InstanceId: {}', $$.Execution.Id, $.accountId, $.instanceId)"
      },
      "ResultPath": null,
      "Next": "StartValidation"
    },
    "StartValidation": {
      "Type": "Task",
      "Resource": "arn:aws:states:::states:startExecution",
      "Parameters": {
        "StateMachineArn": "arn:aws:states:ap-northeast-1:334678299258:stateMachine:monitoring-agent-config-distrubute",
        "Input": {
          "StatePayload": "Hello from Step Functions!",
          "AWS_STEP_FUNCTIONS_STARTED_BY_EXECUTION_ID.$": "$$.Execution.Id"
        }
      },
      "Next": "PrecheckSuccess"
    },
    "PrecheckSuccess": {
      "Type": "Succeed"
    },
    "ParameterNullCheckFailed": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Message.$": "$",
        "TopicArn": "arn:aws:sns:ap-northeast-1:334678299258:monitoring-topic"
      },
      "Next": "PrecheckFail"
    },
    "PrecheckFail": {
      "Type": "Fail"
    }
  },
  "TimeoutSeconds": 3600
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


# ----------------------------------------------------------------------------------------------
# AWS Step Function State Machine
# ----------------------------------------------------------------------------------------------
resource "aws_sfn_state_machine" "this" {
  name     = "${local.prefix}-agent-config-distrubute"
  role_arn = aws_iam_role.sfn.arn

  definition = <<EOF
{
  "Comment": "CloudWatch Agent config auto convert and validation process",
  "StartAt": "Pass",
  "States": {
    "Pass": {
      "Type": "Pass",
      "Next": "ParameterNullChecks",
      "Parameters": {
        "accountId.$": "States.ArrayGetItem(States.StringSplit($.key, '/'), 1)",
        "os.$": "States.ArrayGetItem(States.StringSplit($.key, '/'), 2)",
        "instanceId.$": "States.ArrayGetItem(States.StringSplit($.key, '/'), 3)",
        "bucket.$": "$.bucket",
        "key.$": "$.key"
      }
    },
    "ParameterNullChecks": {
      "Type": "Choice",
      "Choices": [
        {
          "And": [
            {
              "Variable": "$.os",
              "IsPresent": true
            },
            {
              "Variable": "$.accountId",
              "IsPresent": true
            },
            {
              "Variable": "$.instanceId",
              "IsPresent": true
            }
          ],
          "Next": "ParameterOSCheck"
        }
      ],
      "Default": "ParameterNullCheckFailed"
    },
    "ParameterOSCheck": {
      "Type": "Choice",
      "Choices": [
        {
          "Or": [
            {
              "Variable": "$.os",
              "StringEquals": "linux"
            },
            {
              "Variable": "$.os",
              "StringEquals": "windows"
            }
          ],
          "Next": "DescribeInstances"
        }
      ],
      "Default": "OSCheckFailed"
    },
    "DescribeInstances": {
      "Type": "Task",
      "Next": "InstanceExistCheck",
      "Parameters": {
        "InstanceIds.$": "States.Array($.instanceId)"
      },
      "Resource": "arn:aws:states:::aws-sdk:ec2:describeInstances",
      "ResultPath": "$.results"
    },
    "InstanceExistCheck": {
      "Type": "Choice",
      "Choices": [
        {
          "And": [
            {
              "Variable": "$.results.Reservations[0]",
              "IsPresent": true
            },
            {
              "Variable": "$.results.Reservations[0].Instances[0]",
              "IsPresent": true
            }
          ],
          "Next": "Validation Start"
        }
      ],
      "Default": "InstanceExistCheckFailed"
    },
    "InstanceExistCheckFailed": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Message.$": "$",
        "TopicArn": "arn:aws:sns:ap-northeast-1:334678299258:monitoring-topic"
      },
      "Next": "ParameterChecksFailed"
    },
    "OSCheckFailed": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Message.$": "$",
        "TopicArn": "arn:aws:sns:ap-northeast-1:334678299258:monitoring-topic"
      },
      "Next": "ParameterChecksFailed"
    },
    "Validation Start": {
      "Type": "Task",
      "Resource": "arn:aws:states:::aws-sdk:sns:publish",
      "Parameters": {
        "TopicArn": "${aws_sns_topic.nofity.arn}",
        "Subject": "CloudWatch Agent Config Validation Start",
        "Message.$": "States.Format('Workflow Details: https://ap-northeast-1.console.aws.amazon.com/states/home?#/v2/executions/details/{}\nTarget AWS AccountId: {}\nTarget EC2 InstanceId: {}', $$.Execution.Id, $.accountId, $.instanceId)"
      },
      "ResultPath": null,
      "Next": "CloudWatchConfiguationBuild"
    },
    "CloudWatchConfiguationBuild": {
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
      "ResultSelector": {
        "buildId.$": "$.Build.Id",
        "buildStatus.$": "$.Build.BuildStatus"
      },
      "ResultPath": "$.codeBuild",
      "Next": "CheckBuildStatus",
      "TimeoutSeconds": 600
    },
    "ParameterNullCheckFailed": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Message.$": "$",
        "TopicArn": "arn:aws:sns:ap-northeast-1:334678299258:monitoring-topic"
      },
      "Next": "ParameterChecksFailed"
    },
    "ParameterChecksFailed": {
      "Type": "Fail"
    },
    "CheckBuildStatus": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.codeBuild.buildStatus",
          "StringEquals": "SUCCEEDED",
          "Comment": "SUCCEEDED",
          "Next": "CloudWatchConfigurationTest"
        }
      ],
      "Default": "CodeBuildFailed"
    },
    "CloudWatchConfigurationTestFailed": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Message.$": "$",
        "TopicArn": "${aws_sns_topic.nofity.arn}",
      },
      "Next": "ExecutionFailed"
    },
    "CloudWatchConfigurationTest": {
      "Type": "Task",
      "Parameters": {
        "DocumentName": "MyData",
        "Parameters": {
          "taskToken.$": "States.Array($$.Task.Token)"
        }
      },
      "Resource": "arn:aws:states:::aws-sdk:ssm:startAutomationExecution",
      "Next": "CheckTestStatus",
      "TimeoutSeconds": 600
    },
    "CheckTestStatus": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.status",
          "StringEquals": "SUCCESSED",
          "Next": "RequestUserApprove"
        }
      ],
      "Default": "CloudWatchConfigurationTestFailed"
    },
    "RequestUserApprove": {
      "Type": "Task",
      "Parameters": {
        "DocumentName": "monitoring-UserApprove",
        "Parameters": {
          "taskToken.$": "States.Array($$.Task.Token)",
          "buildId.$": "$.buildId"
        }
      },
      "Resource": "arn:aws:states:::aws-sdk:ssm:startAutomationExecution.waitForTaskToken",
      "ResultPath": null,
      "Next": "GetCloudWatchConfigContext",
      "TimeoutSeconds": 1800
    },
    "GetCloudWatchConfigContext": {
      "Type": "Task",
      "Parameters": {
        "Bucket.$": "$.bucket",
        "Key.$": "$.key"
      },
      "Resource": "arn:aws:states:::aws-sdk:s3:getObject",
      "Next": "ConfigureTargetInstance"
    },
    "ConfigureTargetInstance": {
      "Type": "Task",
      "Next": "CloudWatchConfigurationCompleted",
      "Parameters": {
        "DocumentName": "MyData",
        "Parameters": {
          "taskToken.$": "States.Array($$.Task.Token)"
        }
      },
      "Resource": "arn:aws:states:::aws-sdk:ssm:startAutomationExecution",
      "TimeoutSeconds": 600
    },
    "CloudWatchConfigurationCompleted": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Message.$": "$",
        "TopicArn": "arn:aws:sns:ap-northeast-1:334678299258:monitoring-topic"
      },
      "Next": "Success"
    },
    "Success": {
      "Type": "Succeed"
    },
    "CodeBuildFailed": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Message.$": "$",
        "TopicArn": "arn:aws:sns:ap-northeast-1:334678299258:monitoring-topic"
      },
      "Next": "ExecutionFailed"
    },
    "ExecutionFailed": {
      "Type": "Fail"
    }
  },
  "TimeoutSeconds": 3600
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
