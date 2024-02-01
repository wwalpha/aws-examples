# ----------------------------------------------------------------------------------------------
# AWS EC2 Role
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "ec2_ssm" {
  name               = "EC2_SSMRole_${var.suffix}"
  assume_role_policy = data.aws_iam_policy_document.ec2.json

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_instance_profile" "ec2_ssm" {
  name = "ec2_ssm"
  role = aws_iam_role.ec2_ssm.name
}
