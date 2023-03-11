# ----------------------------------------------------------------------------------------------
# AWS EC2 Role Policy - SSM
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

# ----------------------------------------------------------------------------------------------
# AWS RDS Role Policy - RDS Proxy
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "rds_proxy" {
  role       = aws_iam_role.rds_proxy.name
  policy_arn = aws_iam_policy.rds_proxy.arn
}

resource "aws_iam_policy" "rds_proxy" {
  name = "rds_proxy_policy"
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
        ]
        Resource = "*",
        Condition = {
          StringEquals = {
            "kms:ViaService" : "secretsmanager.ap-northeast-1.amazonaws.com"
          }
        }
      }
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# AWS RDS Role Policy - Lambda App
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "lambda_app" {
  role       = aws_iam_role.lambda_app.name
  policy_arn = aws_iam_policy.lambda_app.arn
}

# ----------------------------------------------------------------------------------------------
# AWS IAM Policy - CloudWatch Logs Basic
# ----------------------------------------------------------------------------------------------
resource "aws_iam_policy" "lambda_app" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
