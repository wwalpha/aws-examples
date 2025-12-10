# ----------------------------------------------------------------------------------------------
# Transfer Family - Server
# ----------------------------------------------------------------------------------------------
resource "aws_transfer_server" "this" {
  endpoint_type = "VPC"
  
  endpoint_details {
    subnet_ids         = [aws_subnet.private.id]
    vpc_id             = aws_vpc.this.id
    security_group_ids = [aws_security_group.transfer.id]
  }

  identity_provider_type = "SERVICE_MANAGED"
  
  logging_role = aws_iam_role.transfer_logging.arn

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-server"
  })
}

# ----------------------------------------------------------------------------------------------
# Transfer Family - User
# ----------------------------------------------------------------------------------------------
resource "aws_transfer_user" "test" {
  server_id      = aws_transfer_server.this.id
  user_name      = "testuser"
  role           = aws_iam_role.transfer_user.arn
  
  home_directory_type = "LOGICAL"
  home_directory_mappings {
    entry  = "/"
    target = "/${aws_s3_bucket.transfer.id}/home/testuser"
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-user"
  })
}

# ----------------------------------------------------------------------------------------------
# S3 - Transfer Bucket
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "transfer" {
  bucket = "${local.name_prefix}-transfer-bucket-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
  tags = local.tags
}

# ----------------------------------------------------------------------------------------------
# IAM - Transfer User Role
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "transfer_user" {
  name = "${local.name_prefix}-transfer-user-role"

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
# IAM - Transfer User Policy
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "transfer_user" {
  name = "${local.name_prefix}-transfer-user-policy"
  role = aws_iam_role.transfer_user.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Effect   = "Allow"
        Resource = aws_s3_bucket.transfer.arn
      },
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
          "s3:GetObjectVersion",
          "s3:GetObjectACL",
          "s3:PutObjectACL"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.transfer.arn}/*"
      }
    ]
  })
}
