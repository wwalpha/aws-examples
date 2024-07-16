# ----------------------------------------------------------------------------------------------
# AWS IAM Role - EventBridge Rule
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "events" {
  name               = "${local.prefix}-EventBridgeRole"
  assume_role_policy = data.aws_iam_policy_document.events.json
}

# ----------------------------------------------------------------------------------------------
# AWS IAM Role Policy - EventBridge Rule
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "events" {
  role = aws_iam_role.events.name
  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = "states:StartExecution"
        Resource = [
          "${aws_sfn_state_machine.this.arn}"
        ]
      }
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# AWS IAM Role - Step Function
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "sfn" {
  name               = "${local.prefix}-SFNRole"
  assume_role_policy = data.aws_iam_policy_document.sfn.json
  path               = "/service-role/"
}

# ----------------------------------------------------------------------------------------------
# AWS IAM Role Policy - Step Function
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "sfn" {
  role = aws_iam_role.sfn.name
  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogDelivery",
          "logs:CreateLogStream",
          "logs:GetLogDelivery",
          "logs:UpdateLogDelivery",
          "logs:DeleteLogDelivery",
          "logs:ListLogDeliveries",
          "logs:PutLogEvents",
          "logs:PutResourcePolicy",
          "logs:DescribeResourcePolicies",
          "logs:DescribeLogGroups"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
        ]
        Resource = [
          "*"
        ]
      }
    ]
  })
}
