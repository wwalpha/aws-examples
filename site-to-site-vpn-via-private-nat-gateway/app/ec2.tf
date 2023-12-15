# ----------------------------------------------------------------------------------------------
# AWS Keypair
# ----------------------------------------------------------------------------------------------
resource "aws_key_pair" "this" {
  key_name   = "${var.prefix}_dummy_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}

# ----------------------------------------------------------------------------------------------
# Company A Router Instance
# ----------------------------------------------------------------------------------------------
module "company_a_router" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-CompanyA-Router"
  ami                         = "ami-0404778e217f54308"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.router_sg_company_a.security_group_id]
  subnet_id                   = var.subnet_id_company_a
  associate_public_ip_address = true
  source_dest_check           = false
  iam_instance_profile        = var.ssm_role_profile
}

# ----------------------------------------------------------------------------------------------
# Company A Server Instance
# ----------------------------------------------------------------------------------------------
module "company_a_server" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-CompanyA-Server"
  ami                         = "ami-0404778e217f54308"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.server_sg_company_a.security_group_id]
  subnet_id                   = var.subnet_id_company_a
  associate_public_ip_address = true
  iam_instance_profile        = var.ssm_role_profile
}

# ----------------------------------------------------------------------------------------------
# Company B Router Instance
# ----------------------------------------------------------------------------------------------
module "company_b_router" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-CompanyB-Router"
  ami                         = "ami-0a15fc610e3955298"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.router_sg_company_b.security_group_id]
  subnet_id                   = var.subnet_id_company_b
  associate_public_ip_address = true
  source_dest_check           = false
  iam_instance_profile        = var.ssm_role_profile
}

# ----------------------------------------------------------------------------------------------
# Company B Server Instance
# ----------------------------------------------------------------------------------------------
module "company_b_server" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-CompanyB-Server"
  ami                         = "ami-0404778e217f54308"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.server_sg_company_b.security_group_id]
  subnet_id                   = var.subnet_id_company_b
  associate_public_ip_address = true
  iam_instance_profile        = var.ssm_role_profile
}

# ----------------------------------------------------------------------------------------------
# Company A Server Instance
# ----------------------------------------------------------------------------------------------
module "aws_nginx" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-AWS-NGINX"
  ami                         = "ami-0404778e217f54308"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.aws_sg_nginx.security_group_id]
  subnet_id                   = var.subnet_id_aws_site
  associate_public_ip_address = true
  iam_instance_profile        = var.ssm_role_profile
}
