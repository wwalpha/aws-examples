# ----------------------------------------------------------------------------------------------
# AWS Role - Create Thing Rule Action Role
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "create_thing_rule_action" {
  assume_role_policy = data.aws_iam_policy_document.iot.json
  name               = "${var.prefix}-CreateThingRuleActionRole"

  inline_policy {
    name = "CreateThingRuleActionRoleDefaultPolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["dynamodb:PutItem"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Role - Delete Thing Rule Action Role
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "delete_thing_rule_action" {
  assume_role_policy = data.aws_iam_policy_document.iot.json
  name               = "${var.prefix}-DeleteThingRuleActionRole"

  inline_policy {
    name = "DeleteThingRuleActionRoleDefaultPolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["sqs:SendMessage"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Role - 
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "lambda_create_thing" {
  name                = "${var.prefix}-AWS679f53fac002430cb0da5b7982bd"
  assume_role_policy  = data.aws_iam_policy_document.lambda.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]

  inline_policy {
    name = "AttachPolicyIOTCustomResourcePolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["iot:AttachPolicy", "iot:DetachPolicy"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }

  inline_policy {
    name = "IOTDescribeEndpointCustomResourcePolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["iot:DescribeEndpoint"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }

  inline_policy {
    name = "KeysCertsCustomResourcePolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["iot:CreateKeysAndCertificate", "iot:UpdateCertificate"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }

  inline_policy {
    name = "UpdateEventConfigurationsCustomResourcePolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["iot:UpdateEventConfigurations"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Role - Messages From Charge Points Rule Top 
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "message_from_charge_points_rule_top" {
  name               = "${var.prefix}_MessagesFromChargePointsRuleTopRole"
  assume_role_policy = data.aws_iam_policy_document.iot.json

  inline_policy {
    name = "MessagesFromChargePointsRuleTopicRuleActionRoleDefaultPolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = ["sqs:SendMessage"]
          Effect = "Allow"
          Resource = [
            "arn:aws:sqs:ap-northeast-1:334678299258:AwsOcppGatewayStack-IncomingMessagesQueueFD1163B2-ED9jtZg21ClJ",
          ]
        },
      ]
    })
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Role - Lambda Log Retention
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "log_retention" {
  name                = "${var.prefix}-LogRetentionRole"
  assume_role_policy  = data.aws_iam_policy_document.lambda.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]

  inline_policy {
    name = "LogRetentionServiceRoleDefaultPolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["logs:DeleteRetentionPolicy", "logs:PutRetentionPolicy"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Role - ECS Task Execution Role
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "ecs_task_execution" {
  name                = "${var.prefix}-ECSTaskExecutionRole"
  assume_role_policy  = data.aws_iam_policy_document.ecs_task.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
  inline_policy {
    name = "ExecutionRoleDefaultPolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          "Action" : [
            "ecr:BatchCheckLayerAvailability",
            "ecr:BatchGetImage",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetAuthorizationToken"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Action" : [
            "secretsmanager:DescribeSecret",
            "secretsmanager:GetSecretValue"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        }
      ]
    })
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Role - Delete Thing Role
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "lambda_delete_thing" {
  name                = "${var.prefix}-DeleteThingRole"
  assume_role_policy  = data.aws_iam_policy_document.lambda.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]

  inline_policy {
    name = "DeleteThingServiceRoleDefaultPolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "dynamodb:BatchWriteItem",
            "dynamodb:DeleteItem",
            "dynamodb:DescribeTable",
            "dynamodb:PutItem",
            "dynamodb:UpdateItem",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "sqs:ChangeMessageVisibility",
            "sqs:DeleteMessage",
            "sqs:GetQueueAttributes",
            "sqs:GetQueueUrl",
            "sqs:ReceiveMessage",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Role - ECS Task Role
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "ecs_task" {
  name               = "${var.prefix}-ECSTaskRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task.json

  inline_policy {
    name = "RoleDefaultPolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "dynamodb:BatchGetItem",
            "dynamodb:ConditionCheckItem",
            "dynamodb:DescribeTable",
            "dynamodb:GetItem",
            "dynamodb:GetRecords",
            "dynamodb:GetShardIterator",
            "dynamodb:Query",
            "dynamodb:Scan"
          ]
          Resource = "*"
        },
        {
          Effect = "Allow"
          Action = [
            "secretsmanager:DescribeSecret",
            "secretsmanager:GetSecretValue"
          ]
          Resource = "*"
        },
        {
          Effect = "Allow"
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Resource = "*"
        },
      ]
    })
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Role - Lambda Message Processor
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "message_processor" {
  name               = "${var.prefix}-OCPPMessageProcessorRole"
  assume_role_policy = data.aws_iam_policy_document.lambda.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]

  inline_policy {
    name = "OCPPMessageProcessorServiceRoleDefaultPolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "sqs:ChangeMessageVisibility",
            "sqs:DeleteMessage",
            "sqs:GetQueueAttributes",
            "sqs:GetQueueUrl",
            "sqs:ReceiveMessage"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }

  inline_policy {
    name = "PublishToOutTopicPolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "iot:Publish"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }
}
