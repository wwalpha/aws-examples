# ----------------------------------------------------------------------------------------------
# IAM - Transfer Logging Role
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "transfer_logging" {
  name = "${local.name_prefix}-transfer-logging-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "transfer.amazonaws.com"
        }
      }
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM - Transfer Logging Policy
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "transfer_logging" {
  name = "${local.name_prefix}-transfer-logging-policy"
  role = aws_iam_role.transfer_logging.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:CreateLogGroup",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM - EC2 SSM Role
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "ec2_ssm" {
  name = "${local.name_prefix}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM - EC2 SSM Policy Attachment
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ----------------------------------------------------------------------------------------------
# IAM - EC2 Instance Profile
# ----------------------------------------------------------------------------------------------
resource "aws_iam_instance_profile" "ec2_ssm" {
  name = "${local.name_prefix}-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm.name
}
