# ----------------------------------------------------------------------------------------------
# AWS IAM Instance Profile - EC2 SSM
# ----------------------------------------------------------------------------------------------
resource "aws_iam_instance_profile" "this" {
  name = "ec2_ssm"
  role = var.ec2_ssm_role_name
}

# ----------------------------------------------------------------------------------------------
# AWS EC2 Instance - Nginx
# ----------------------------------------------------------------------------------------------
module "nginx" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "${var.prefix}-nginx"

  ami                    = "ami-0404778e217f54308"
  instance_type          = "t3a.medium"
  key_name               = "onecloud"
  monitoring             = false
  vpc_security_group_ids = [module.app_sg.security_group_id]
  subnet_id              = var.private_subnets_app[0]
  user_data_base64       = base64encode(local.user_data)
  iam_instance_profile   = aws_iam_instance_profile.this.name
}

# module "ec2_instance2" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "~> 3.0"

#   name = "nfw-instance2"

#   ami                    = "ami-0404778e217f54308"
#   instance_type          = "t3a.medium"
#   key_name               = "onecloud"
#   monitoring             = false
#   vpc_security_group_ids = [module.app_sg.security_group_id]
#   subnet_id              = var.private_subnets[1]
#   iam_instance_profile   = var.ec2_ssm_role_profile
# }

