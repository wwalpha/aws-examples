# ----------------------------------------------------------------------------------------------
# IAM Instance Profile - Application
# ----------------------------------------------------------------------------------------------
resource "aws_iam_instance_profile" "app" {
  name = "${var.env_name}_app_profile"
  role = aws_iam_role.app.name
}

# ----------------------------------------------------------------------------------------------
# IAM Instance Profile - Batch
# ----------------------------------------------------------------------------------------------
resource "aws_iam_instance_profile" "batch" {
  name = "${var.env_name}_batch_profile"
  role = aws_iam_role.batch.name
}

# ----------------------------------------------------------------------------------------------
# IAM Role - Application
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "app" {
  name = "LAW_${upper(var.env_name)}_AppRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM Role Policy - Application
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "app_s3" {
  name = "s3_policy"
  role = aws_iam_role.app.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:Get*",
          "s3:List*",
          "s3:PutObject*",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.this.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.this.bucket}/*",
          "arn:aws:s3:::${aws_s3_bucket.security.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.security.bucket}/*"
        ]
      },
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM Role Policy - Application
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "app_codedeploy" {
  name = "codedeploy_policy"
  role = aws_iam_role.app.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
        ]
        Resource = [
          "arn:aws:s3:::lawson-build-artifacts",
          "arn:aws:s3:::lawson-build-artifacts/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "codedeploy-commands-secure:PollHostCommand",
          "codedeploy-commands-secure:PutHostCommandComplete",
          "codedeploy-commands-secure:PutHostCommandAcknowledgement",
          "codedeploy-commands-secure:GetDeploymentSpecification"
        ]
        Resource = ["*"]
      },
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM Role Policy - Application
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "app_ssm" {
  name = "ssm_policy"
  role = aws_iam_role.app.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:DescribeAssociation",
          "ssm:GetDeployablePatchSnapshotForInstance",
          "ssm:GetDocument",
          "ssm:DescribeDocument",
          "ssm:GetManifest",
          "ssm:GetParameters",
          "ssm:ListAssociations",
          "ssm:ListInstanceAssociations",
          "ssm:PutInventory",
          "ssm:PutComplianceItems",
          "ssm:PutConfigurePackageResult",
          "ssm:UpdateAssociationStatus",
          "ssm:UpdateInstanceAssociationStatus",
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "ec2messages:AcknowledgeMessage",
          "ec2messages:DeleteMessage",
          "ec2messages:FailMessage",
          "ec2messages:GetEndpoint",
          "ec2messages:GetMessages",
          "ec2messages:SendReply"
        ]
        Resource = ["*"]
      },

    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM Role Policy - Application
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "app_kms" {
  name = "kms_policy"
  role = aws_iam_role.app.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = ["*"]
      },

    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM Role Policy - Application
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "app_installations" {
  name = "installations_policy"
  role = aws_iam_role.app.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::lawson-installations/*",
          "arn:aws:s3:::lawson-installations"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::lawson-batch-artifacts",
          "arn:aws:s3:::lawson-batch-artifacts/*"
        ]
      },
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM Role Policy - Application
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "app_cloudwatch" {
  name = "cloudwatch_policy"
  role = aws_iam_role.app.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "cloudwatch:PutMetricData",
          "logs:CreateLogGroup",
          "logs:PutLogEvents"
        ]
        Resource = [
          "*"
        ]
      },
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM Role - Batch
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "batch" {
  name = "LAW_${upper(var.env_name)}_BatchRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM Role Policy - Batch
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "batch" {
  name = "inline_policy"
  role = aws_iam_role.batch.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:Get*",
          "s3:List*",
          "s3:PutObject*",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.this.bucket}/*",
          "arn:aws:s3:::${aws_s3_bucket.this.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.security.bucket}/*",
          "arn:aws:s3:::${aws_s3_bucket.security.bucket}"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "rds:DescribeDBSnapshots",
          "rds:CreateDBSnapshot",
          "rds:DescribeDBInstances",
          "rds:DeleteDBSnapshot"
        ]
        Resource = length(aws_db_instance.app) == 0 ? [
          "arn:aws:rds:ap-northeast-1:694674946705:snapshot:*",
          ] : [
          "${aws_db_instance.app[0].arn}",
          "arn:aws:rds:ap-northeast-1:694674946705:snapshot:*",
        ]
      }
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM Role Policy - Batch
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "batch_codedeploy" {
  name = "codedeploy_policy"
  role = aws_iam_role.batch.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
        ]
        Resource = [
          "arn:aws:s3:::lawson-build-artifacts",
          "arn:aws:s3:::lawson-build-artifacts/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "codedeploy-commands-secure:PollHostCommand",
          "codedeploy-commands-secure:PutHostCommandComplete",
          "codedeploy-commands-secure:PutHostCommandAcknowledgement",
          "codedeploy-commands-secure:GetDeploymentSpecification"
        ]
        Resource = ["*"]
      },
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM Role Policy - Batch
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "batch_ssm" {
  name = "ssm_policy"
  role = aws_iam_role.batch.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:DescribeAssociation",
          "ssm:GetDeployablePatchSnapshotForInstance",
          "ssm:GetDocument",
          "ssm:DescribeDocument",
          "ssm:GetManifest",
          "ssm:GetParameters",
          "ssm:ListAssociations",
          "ssm:ListInstanceAssociations",
          "ssm:PutInventory",
          "ssm:PutComplianceItems",
          "ssm:PutConfigurePackageResult",
          "ssm:UpdateAssociationStatus",
          "ssm:UpdateInstanceAssociationStatus",
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "ec2messages:AcknowledgeMessage",
          "ec2messages:DeleteMessage",
          "ec2messages:FailMessage",
          "ec2messages:GetEndpoint",
          "ec2messages:GetMessages",
          "ec2messages:SendReply"
        ]
        Resource = ["*"]
      },

    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM Role Policy - Batch
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "batch_kms" {
  name = "kms_policy"
  role = aws_iam_role.batch.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = ["*"]
      },

    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM Role Policy - Batch
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "batch_installations" {
  name = "installations_policy"
  role = aws_iam_role.batch.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::lawson-installations/*",
          "arn:aws:s3:::lawson-installations"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::lawson-batch-artifacts",
          "arn:aws:s3:::lawson-batch-artifacts/*"
        ]
      },
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM Role Policy - Batch
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "batch_cloudwatch" {
  name = "cloudwatch_policy"
  role = aws_iam_role.batch.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "cloudwatch:PutMetricData",
          "logs:CreateLogGroup",
          "logs:PutLogEvents"
        ]
        Resource = [
          "*"
        ]
      },
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM Role - CodeDeploy
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "codedeploy" {
  name = "LAW_${upper(var.env_name)}_CodeDeployRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      },
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# IAM Role Policy - CodeDeploy
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "codedeploy_ec2" {
  name = "ec2_policy"
  role = aws_iam_role.codedeploy.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:PassRole",
          "ec2:CreateTags",
          "ec2:RunInstances"
        ]
        Resource = [
          "*"
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy" {
  role       = aws_iam_role.codedeploy.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}
