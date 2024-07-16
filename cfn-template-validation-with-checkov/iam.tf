# ----------------------------------------------------------------------------------------------
# AWS IAM Role - CodeBuild
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "codebuild" {
  name               = "${local.prefix}-CodeBuildRole"
  assume_role_policy = data.aws_iam_policy_document.codebuild.json
}

# ----------------------------------------------------------------------------------------------
# AWS IAM Role Policy - CodeBuild
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "codebuild" {
  role = aws_iam_role.codebuild.name
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
        Action = "s3:*"
        Resource = [
          "${aws_s3_bucket.this.arn}",
          "${aws_s3_bucket.this.arn}/*",
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases"
        ]
        Resource = [
          "*"
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
          "events:PutTargets",
          "events:PutRule",
          "events:DescribeRule"
        ]
        Resource = [
          "*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "sns:Publish",
        ]
        Resource = [
          "${aws_sns_topic.nofity.arn}"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "codebuild:StartBuild",
          "codebuild:StopBuild",
          "codebuild:BatchGetBuilds",
          "codebuild:BatchGetReports",
        ]
        Resource = [
          "*"
        ]
      }
    ]
  })
}

# # ----------------------------------------------------------------------------------------------
# # AWS IAM Role - Step Function
# # ----------------------------------------------------------------------------------------------
# resource "aws_iam_role" "sfn_validate" {
#   name               = "${local.prefix}-SFN-ValidateRole"
#   assume_role_policy = data.aws_iam_policy_document.sfn.json
# }

# # ----------------------------------------------------------------------------------------------
# # AWS IAM Role Policy - Step Function
# # ----------------------------------------------------------------------------------------------
# resource "aws_iam_role_policy" "sfn_validate" {
#   role = aws_iam_role.sfn_validate.name
#   policy = jsonencode({
#     Version = "2012-10-17"

#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "logs:CreateLogDelivery",
#           "logs:CreateLogStream",
#           "logs:GetLogDelivery",
#           "logs:UpdateLogDelivery",
#           "logs:DeleteLogDelivery",
#           "logs:ListLogDeliveries",
#           "logs:PutLogEvents",
#           "logs:PutResourcePolicy",
#           "logs:DescribeResourcePolicies",
#           "logs:DescribeLogGroups"
#         ]
#         Resource = "*"
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "sns:Publish",
#         ]
#         Resource = [
#           "${aws_sns_topic.nofity.arn}"
#         ]
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "states:StartExecution",
#         ]
#         Resource = [
#           "${aws_sfn_state_machine.validate.arn}"
#         ]
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "ssm:PutParameter",
#           "ssm:SendCommand"
#         ]
#         Resource = [
#           "*"
#         ]
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "ssm:StartAutomationExecution",
#           "s3:GetObject",
#         ]
#         Resource = "*"
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "states:SendTaskSuccess",
#           "states:SendTaskFailure"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }


# ----------------------------------------------------------------------------------------------
# AWS IAM Role - Events
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "events" {
  name               = "${local.prefix}-EventsRole"
  path               = "/service-role/"
  assume_role_policy = data.aws_iam_policy_document.events.json
}

# ----------------------------------------------------------------------------------------------
# AWS IAM Role Policy - Events Rule
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "events" {
  role = aws_iam_role.events.name
  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"
        Action = [
          "states:StartExecution",
        ]
        Resource = "${aws_sfn_state_machine.this.arn}"
      }
    ]
  })
}

