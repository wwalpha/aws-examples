# ----------------------------------------------------------------------------------------------
# AWS Provider
# ----------------------------------------------------------------------------------------------
provider "aws" {}

terraform {
  backend "local" {
    path = "./tfstate/terraform.tfstate"
  }
}

module "security" {
  source = "./security"
  prefix = local.prefix
}


module "networking" {
  source = "./networking"
  prefix = local.prefix
}

module "app" {
  source              = "./app"
  prefix              = local.prefix
  subnet_id_company_a = module.networking.subnet_id_company_a
  subnet_id_company_b = module.networking.subnet_id_company_b
  subnet_id_aws_site  = module.networking.subnet_id_aws_site
  vpc_id_company_a    = module.networking.vpc_id_company_a
  vpc_id_company_b    = module.networking.vpc_id_company_b
  vpc_id_aws_site     = module.networking.vpc_id_aws_site
  ssm_role_profile    = module.security.iam_role_profile_ec2_ssm
  keypair_name        = "onecloud"
}

module "site_to_site_vpn" {
  depends_on              = [module.app]
  source                  = "./vpn"
  prefix                  = local.prefix
  ip_cidr_company_a       = module.networking.ip_cidr_company_a
  ip_cidr_company_b       = module.networking.ip_cidr_company_b
  ip_cidr_aws_site        = module.networking.ip_cidr_aws_site
  company_a_public_ip     = module.app.linux_router_public_ip
  company_b_public_ip     = module.app.windows_router_public_ip
  vpc_id_aws_site         = module.networking.vpc_id_aws_site
  route_table_id_aws_site = module.networking.route_table_id_aws_site
}
