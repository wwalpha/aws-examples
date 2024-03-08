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
  instance_type          = "t3a.small"
  key_name               = "onecloud"
  monitoring             = false
  vpc_security_group_ids = [module.workload_sg.security_group_id]
  subnet_id              = var.vpc_subnets_workload_private[0]
  # user_data_base64       = base64encode(local.user_data)
  iam_instance_profile = aws_iam_instance_profile.this.name
  source_dest_check    = false
}

# ----------------------------------------------------------------------------------------------
# AWS EC2 Instance - Checker
# ----------------------------------------------------------------------------------------------
module "ingress" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "${var.prefix}-ingress-checker"

  ami                    = "ami-0404778e217f54308"
  instance_type          = "t3a.small"
  key_name               = "onecloud"
  monitoring             = false
  vpc_security_group_ids = [module.ingress_sg.security_group_id]
  subnet_id              = var.vpc_subnets_ingress_public[0]
  # user_data_base64       = base64encode(local.user_data)
  iam_instance_profile        = aws_iam_instance_profile.this.name
  source_dest_check           = false
  associate_public_ip_address = true
}
