resource "random_id" "this" {
  byte_length = 4
}

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
resource "aws_iam_role" "this" {
  name               = "EC2_SSMRole${random_id.this.hex}"
  assume_role_policy = data.aws_iam_policy_document.ec2.json

  lifecycle {
    create_before_destroy = false
  }
}

# ----------------------------------------------------------------------------------------------
# AWS EC2 Role Policy - SSM
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "this" {
  name = "ssm"
  role = aws_iam_role.this.name
}
