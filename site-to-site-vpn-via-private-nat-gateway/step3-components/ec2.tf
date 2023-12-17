# ----------------------------------------------------------------------------------------------
# Router Instance for OnPremise A
# ----------------------------------------------------------------------------------------------
module "router_for_onpremise_a" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-Router-for-OnPremiseA"
  ami                         = "ami-0404778e217f54308"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.router_sg_onpremise_a.security_group_id]
  subnet_id                   = var.subnet_id_onpremise_a
  associate_public_ip_address = true
  source_dest_check           = false
  user_data_base64            = base64encode(local.openswan_user_data)
  iam_instance_profile        = var.ssm_role_profile
}

# ----------------------------------------------------------------------------------------------
# Server Instance for OnPremise A
# ----------------------------------------------------------------------------------------------
module "server_for_onpremise_a" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-Server-for-OnPremiseA"
  ami                         = "ami-0404778e217f54308"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.router_sg_onpremise_a.security_group_id]
  subnet_id                   = var.subnet_id_onpremise_a
  associate_public_ip_address = true
  iam_instance_profile        = var.ssm_role_profile
}

# ----------------------------------------------------------------------------------------------
# Router Instance for OnPremise B
# ----------------------------------------------------------------------------------------------
module "router_for_onpremise_b" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-Router-for-OnPremiseA"
  ami                         = "ami-0404778e217f54308"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.router_sg_onpremise_b.security_group_id]
  subnet_id                   = var.subnet_id_onpremise_b
  associate_public_ip_address = true
  source_dest_check           = false
  user_data_base64            = base64encode(local.openswan_user_data)
  iam_instance_profile        = var.ssm_role_profile
}

# ----------------------------------------------------------------------------------------------
# Server Instance for OnPremise B
# ----------------------------------------------------------------------------------------------
module "server_for_onpremise_b" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-Server-for-OnPremiseB"
  ami                         = "ami-0404778e217f54308"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.router_sg_onpremise_b.security_group_id]
  subnet_id                   = var.subnet_id_onpremise_b
  associate_public_ip_address = true
  iam_instance_profile        = var.ssm_role_profile
}

# ----------------------------------------------------------------------------------------------
# Proxy Instance for Relay A
# ----------------------------------------------------------------------------------------------
module "proxy_for_relay_a" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-Proxy-for-RelayA"
  ami                         = "ami-0404778e217f54308"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.proxy_sg_relay_a.security_group_id]
  subnet_id                   = var.subnet_id_aws_relay_a
  associate_public_ip_address = true
  user_data_base64            = base64encode(local.proxy_user_data)
  iam_instance_profile        = var.ssm_role_profile
}

# ----------------------------------------------------------------------------------------------
# Proxy Instance for Relay A
# ----------------------------------------------------------------------------------------------
module "proxy_for_relay_b" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-Proxy-for-RelayB"
  ami                         = "ami-0404778e217f54308"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.proxy_sg_relay_b.security_group_id]
  subnet_id                   = var.subnet_id_aws_relay_b
  associate_public_ip_address = true
  user_data_base64            = base64encode(local.proxy_user_data)
  iam_instance_profile        = var.ssm_role_profile
}

# ----------------------------------------------------------------------------------------------
# AWS Side Server Instance
# ----------------------------------------------------------------------------------------------
module "aws_nginx" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-AWS-NGINX"
  ami                         = "ami-0404778e217f54308"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.nginx_sg.security_group_id]
  subnet_id                   = var.subnet_id_aws_app
  associate_public_ip_address = true
  user_data_base64            = base64encode(local.proxy_user_data)
  iam_instance_profile        = var.ssm_role_profile
}