# ----------------------------------------------------------------------------------------------
# AWS IAM Policy Document - EC2
# ----------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "ec2" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# ----------------------------------------------------------------------------------------------
# AWS EC2 Role
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "ec2_ssm" {
  name               = "${upper(var.prefix)}_EC2_SSMRole"
  assume_role_policy = data.aws_iam_policy_document.ec2.json

  lifecycle {
    create_before_destroy = false
  }
}

# ----------------------------------------------------------------------------------------------
# AWS EC2 Role Policy Attachment
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
