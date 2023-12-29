# ----------------------------------------------------------------------------------------------
# Router Instance for OnPremise EU
# ----------------------------------------------------------------------------------------------
module "router_for_onpremise_eu" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-Router-for-OnPremiseEU"
  ami                         = "ami-0404778e217f54308"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.router_sg_onpremise_eu.security_group_id]
  subnet_id                   = var.subnet_id_onpremise_eu
  associate_public_ip_address = true
  source_dest_check           = false
  user_data_base64            = base64encode(local.openswan_user_data)
  iam_instance_profile        = var.ssm_role_profile
}

# ----------------------------------------------------------------------------------------------
# Server Instance for OnPremise EU
# ----------------------------------------------------------------------------------------------
module "server_for_onpremise_eu" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-Server-for-OnPremiseEU"
  ami                         = "ami-0404778e217f54308"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.router_sg_onpremise_eu.security_group_id]
  subnet_id                   = var.subnet_id_onpremise_eu
  associate_public_ip_address = true
  iam_instance_profile        = var.ssm_role_profile
}

# ----------------------------------------------------------------------------------------------
# Router Instance for OnPremise US
# ----------------------------------------------------------------------------------------------
module "router_for_onpremise_us" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-Router-for-OnPremiseUS"
  ami                         = "ami-0404778e217f54308"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.router_sg_onpremise_us.security_group_id]
  subnet_id                   = var.subnet_id_onpremise_us
  associate_public_ip_address = true
  source_dest_check           = false
  user_data_base64            = base64encode(local.openswan_user_data)
  iam_instance_profile        = var.ssm_role_profile
}

# ----------------------------------------------------------------------------------------------
# Server Instance for OnPremise US
# ----------------------------------------------------------------------------------------------
module "server_for_onpremise_us" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-Server-for-OnPremiseUS"
  ami                         = "ami-0404778e217f54308"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.router_sg_onpremise_us.security_group_id]
  subnet_id                   = var.subnet_id_onpremise_us
  associate_public_ip_address = true
  iam_instance_profile        = var.ssm_role_profile
}


# ----------------------------------------------------------------------------------------------
# Router Instance for OnPremise JP
# ----------------------------------------------------------------------------------------------
module "router_for_onpremise_jp" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-Router-for-OnPremiseJP"
  ami                         = "ami-0404778e217f54308"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.router_sg_onpremise_jp.security_group_id]
  subnet_id                   = var.subnet_id_onpremise_jp
  associate_public_ip_address = true
  source_dest_check           = false
  user_data_base64            = base64encode(local.openswan_user_data)
  iam_instance_profile        = var.ssm_role_profile
}

# ----------------------------------------------------------------------------------------------
# Server Instance for OnPremise JP
# ----------------------------------------------------------------------------------------------
module "server_for_onpremise_jp" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-Server-for-OnPremiseJP"
  ami                         = "ami-0404778e217f54308"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.router_sg_onpremise_us.security_group_id]
  subnet_id                   = var.subnet_id_onpremise_us
  associate_public_ip_address = true
  iam_instance_profile        = var.ssm_role_profile
}

# ----------------------------------------------------------------------------------------------
# Proxy Instance for Relay EU
# ----------------------------------------------------------------------------------------------
module "proxy_for_relay_eu" {
  depends_on                  = [module.aws_application]
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-Proxy-for-RelayEU"
  ami                         = "ami-0404778e217f54308"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.proxy_sg_relay_eu.security_group_id]
  subnet_id                   = var.subnet_id_aws_relay_eu
  associate_public_ip_address = true
  user_data_base64            = base64encode(local.proxy_user_data)
  iam_instance_profile        = var.ssm_role_profile
}

# ----------------------------------------------------------------------------------------------
# Proxy Instance for Relay US
# ----------------------------------------------------------------------------------------------
module "proxy_for_relay_us" {
  depends_on                  = [module.aws_application]
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-Proxy-for-RelayUS"
  ami                         = "ami-0404778e217f54308"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.proxy_sg_relay_us.security_group_id]
  subnet_id                   = var.subnet_id_aws_relay_us
  associate_public_ip_address = true
  user_data_base64            = base64encode(local.proxy_user_data)
  iam_instance_profile        = var.ssm_role_profile
}

# ----------------------------------------------------------------------------------------------
# Proxy Instance for Relay JP
# ----------------------------------------------------------------------------------------------
module "proxy_for_relay_jp" {
  depends_on                  = [module.aws_application]
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-Proxy-for-RelayJP"
  ami                         = "ami-0404778e217f54308"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.proxy_sg_relay_jp.security_group_id]
  subnet_id                   = var.subnet_id_aws_relay_jp
  associate_public_ip_address = true
  user_data_base64            = base64encode(local.proxy_user_data)
  iam_instance_profile        = var.ssm_role_profile
}

# ----------------------------------------------------------------------------------------------
# AWS Side Server Instance
# ----------------------------------------------------------------------------------------------
module "aws_application" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "${var.prefix}-AWS-Application"
  ami                         = "ami-0404778e217f54308"
  instance_type               = "t3a.small"
  key_name                    = var.keypair_name
  monitoring                  = false
  vpc_security_group_ids      = [module.nginx_sg.security_group_id]
  subnet_id                   = var.subnet_id_aws_app
  associate_public_ip_address = true
  user_data_base64            = base64encode(local.application_user_data)
  iam_instance_profile        = var.ssm_role_profile
}
