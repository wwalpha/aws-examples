# ----------------------------------------------------------------------------------------------
# AWS Role - EC2
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "ec2_ssm" {
  name               = "${var.prefix}_EC2_SSMRole"
  assume_role_policy = data.aws_iam_policy_document.ec2.json

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_instance_profile" "ec2_ssm" {
  name = "ec2_ssm"
  role = aws_iam_role.ec2_ssm.name
}

# ----------------------------------------------------------------------------------------------
# AWS Role - Lambda
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "lambda_app" {
  name               = "${var.prefix}LambdaAppRole"
  assume_role_policy = data.aws_iam_policy_document.lambda.json

  lifecycle {
    create_before_destroy = false
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Role
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "rds_proxy" {
  name               = "${var.prefix}_RDS_ProxyRole"
  assume_role_policy = data.aws_iam_policy_document.rds.json

  lifecycle {
    create_before_destroy = false
  }
}
