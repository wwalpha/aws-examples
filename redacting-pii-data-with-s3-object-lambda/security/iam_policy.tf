# ----------------------------------------------------------------------------------------------
# IAM Policy - Lambda Basic
# ----------------------------------------------------------------------------------------------
resource "aws_iam_policy" "lambda_basic" {
  name = "LambdaBasicPoliy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
