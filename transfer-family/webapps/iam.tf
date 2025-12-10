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
# IAM - S3 Access Grants Role
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "s3_access_grants" {
  name = "${local.name_prefix}-s3-access-grants-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:SetContext"
        ]
        Effect = "Allow"
        Principal = {
          Service = "access-grants.s3.amazonaws.com"
        }
      }
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM - S3 Access Grants Policy
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "s3_access_grants" {
  name = "${local.name_prefix}-s3-access-grants-policy"
  role = aws_iam_role.s3_access_grants.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.transfer.arn,
          "${aws_s3_bucket.transfer.arn}/*",
          aws_s3_bucket.transfer_2.arn,
          "${aws_s3_bucket.transfer_2.arn}/*"
        ]
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
# IAM - Instance Profile
# ----------------------------------------------------------------------------------------------
resource "aws_iam_instance_profile" "ec2_ssm" {
  name = "${local.name_prefix}-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm.name
}

# ----------------------------------------------------------------------------------------------
# IAM - Web App Role
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "webapp" {
  name = "${local.name_prefix}-webapp-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:SetContext"
        ]
        Effect = "Allow"
        Principal = {
          Service = "transfer.amazonaws.com"
        }
      }
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM - Web App Policy
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "webapp" {
  name = "${local.name_prefix}-webapp-policy"
  role = aws_iam_role.webapp.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetDataAccess",
          "s3:ListCallerAccessGrants",
          "s3:ListAccessGrantsInstances"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
