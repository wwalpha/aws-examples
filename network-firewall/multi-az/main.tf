# ----------------------------------------------------------------------------------------------
# AWS Provider
# ----------------------------------------------------------------------------------------------
provider "aws" {}

terraform {
  backend "local" {
    path = "./tfstate/terraform.tfstate"
  }
}

module "networking" {
  source = "./step1-networking"
  prefix = local.prefix
}

module "security" {
  source = "./step2-security"
  prefix = local.prefix
}

module "app" {
  source                  = "./step3-app"
  prefix                  = local.prefix
  vpc_id_dmz              = module.networking.vpc_id_dmz
  vpc_id_app              = module.networking.vpc_id_app
  vpc_subnets_app_private = module.networking.vpc_subnets_app_private
  vpc_subnets_dmz_intra   = module.networking.vpc_subnets_dmz_intra
  ec2_ssm_role_name       = module.security.ec2_ssm_role.name
}
