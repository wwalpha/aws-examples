# ----------------------------------------------------------------------------------------------
# AWS EC2 Role
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "ec2_ssm" {
  name               = "${upper(var.prefix)}_EC2_SSMRole"
  assume_role_policy = data.aws_iam_policy_document.ec2.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  lifecycle {
    create_before_destroy = false
  }
}
