# ----------------------------------------------------------------------------------------------
# AWS IAM Instance Profile - EC2 SSM
# ----------------------------------------------------------------------------------------------
resource "aws_iam_instance_profile" "this" {
  name = "ec2_ssm"
  role = aws_iam_role.ec2_ssm.name
}

# ----------------------------------------------------------------------------------------------
# AWS EC2 Instance - Nginx DNS Server
# ----------------------------------------------------------------------------------------------
module "nginx" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "${var.prefix}-nginx"

  ami                    = "ami-0ab3794db9457b60a"
  instance_type          = "t3a.medium"
  key_name               = "resolver-testing"
  monitoring             = false
  vpc_security_group_ids = [module.sg.security_group_id]
  subnet_id              = var.vpc_private_subnet_ids[0]
  iam_instance_profile   = aws_iam_instance_profile.this.name
  source_dest_check      = false
  user_data              = local.user_data_nginx

  metadata_options = {
    http_tokens = "required"
  }
}
