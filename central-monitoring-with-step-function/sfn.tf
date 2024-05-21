# ----------------------------------------------------------------------------------------------
# AWS Step Function State Machine - Config PreCheck
# ----------------------------------------------------------------------------------------------
resource "aws_sfn_state_machine" "precheck" {
  name     = "${local.prefix}-cwconfig-precheck"
  role_arn = aws_iam_role.sfn_precheck.arn

  definition = <<EOF
{
  "Comment": "CloudWatch config validation process",
  "StartAt": "Pass",
  "States": {
    "Pass": {
      "Type": "Pass",
      "Next": "CheckParameterNull",
      "Parameters": {
        "accountId.$": "States.ArrayGetItem(States.StringSplit($.key, '/'), 2)",
        "os.$": "States.ArrayGetItem(States.StringSplit($.key, '/'), 1)",
        "instanceId.$": "States.ArrayGetItem(States.StringSplit($.key, '/'), 3)",
        "bucket.$": "$.bucket",
        "key.$": "$.key"
      }
    },
    "CheckParameterNull": {
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
          "Next": "CheckOSType"
        }
      ],
      "Default": "ParameterHasNull"
    },
    "CheckOSType": {
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
            },
            {
              "Variable": "$.os",
              "StringEquals": "windows-legacy"
            }
          ],
          "Next": "DescribeInstances"
        }
      ],
      "Default": "OSTypeCheckFailed"
    },
    "DescribeInstances": {
      "Type": "Task",
      "Next": "CheckInstanceExist",
      "Parameters": {
        "InstanceIds.$": "States.Array($.instanceId)"
      },
      "Resource": "arn:aws:states:::aws-sdk:ec2:describeInstances",
      "ResultPath": "$.results",
      "ResultSelector": {
        "StatusCode.$": "$.Reservations[0].Instances[0].State.Code"
      }
    },
    "CheckInstanceExist": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.results.StatusCode",
          "IsPresent": true,
          "Next": "CheckInstanceRunning"
        }
      ],
      "Default": "InstanceNotExist"
    },
    "CheckInstanceRunning": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.results.StatusCode",
          "NumericEquals": 16,
          "Next": "Validation Start"
        }
      ],
      "Default": "InstanceNotRunning"
    },
    "InstanceNotExist": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Message.$": "$",
        "TopicArn": "arn:aws:sns:ap-northeast-1:334678299258:monitoring-topic"
      },
      "Next": "PrecheckFail"
    },
    "OSTypeCheckFailed": {
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
      "Next": "TransformPayload"
    },
    "TransformPayload": {
      "Type": "Pass",
      "Next": "StartValidation",
      "Parameters": {
        "accountId.$": "$.accountId",
        "os.$": "$.os",
        "instanceId.$": "$.instanceId",
        "bucket.$": "$.bucket",
        "key.$": "$.key"
      }
    },
    "StartValidation": {
      "Type": "Task",
      "Resource": "arn:aws:states:::states:startExecution",
      "Parameters": {
        "StateMachineArn": "arn:aws:states:ap-northeast-1:334678299258:stateMachine:monitoring-cwconfig-validate",
        "Input": {
          "StatePayload.$": "$",
          "AWS_STEP_FUNCTIONS_STARTED_BY_EXECUTION_ID.$": "$$.Execution.Id"
        }
      },
      "Next": "PrecheckSuccess"
    },
    "PrecheckSuccess": {
      "Type": "Succeed"
    },
    "ParameterHasNull": {
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
    },
    "InstanceNotRunning": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "Message.$": "$",
        "TopicArn": "arn:aws:sns:ap-northeast-1:334678299258:monitoring-topic"
      },
      "Next": "PrecheckFail"
    }
  },
  "TimeoutSeconds": 3600
}
EOF

  # logging_configuration {
  #   log_destination        = "${aws_cloudwatch_log_group.sfn.arn}:*"
  #   include_execution_data = true
  #   level                  = "ALL"
  # }

  lifecycle {
    ignore_changes = [definition]
  }
}


# ----------------------------------------------------------------------------------------------
# AWS Step Function State Machine
# ----------------------------------------------------------------------------------------------
resource "aws_sfn_state_machine" "validate" {
  name     = "${local.prefix}-cwconfig-validate"
  role_arn = aws_iam_role.sfn_validate.arn

  definition = <<EOF
{
  "Comment": "A description of my state machine",
  "StartAt": "Pass",
  "States": {
    "Pass": {
      "Type": "Pass",
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


resource "aws_sfn_state_machine" "delivery" {
  name     = "${local.prefix}-cwconfig-delivery"
  role_arn = aws_iam_role.sfn_delivery.arn

  definition = <<EOF
{
  "Comment": "A description of my state machine",
  "StartAt": "Pass",
  "States": {
    "Pass": {
      "Type": "Pass",
      "End": true
    }
  }
}
EOF
}

