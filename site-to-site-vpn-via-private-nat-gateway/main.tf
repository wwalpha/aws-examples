# ----------------------------------------------------------------------------------------------
# AWS Provider
# ----------------------------------------------------------------------------------------------
provider "aws" {}

terraform {
  backend "local" {
    path = "./tfstate/terraform.tfstate"
  }
}

module "step1-networking" {
  source = "./step1-networking"
  prefix = local.prefix
}

module "step2-security" {
  source = "./step2-security"
  prefix = local.prefix
}

module "step3-components" {
  depends_on             = [module.step1-networking, module.step2-security]
  source                 = "./step3-components"
  prefix                 = local.prefix
  subnet_id_onpremise_eu = module.step1-networking.subnet_id_onpremise_eu
  subnet_id_onpremise_us = module.step1-networking.subnet_id_onpremise_us
  subnet_id_aws_relay_eu = module.step1-networking.subnet_id_aws_relay_eu
  subnet_id_aws_relay_us = module.step1-networking.subnet_id_aws_relay_us
  subnet_id_aws_app      = module.step1-networking.subnet_id_aws_app
  vpc_id_onpremise_eu    = module.step1-networking.vpc_id_onpremise_eu
  vpc_id_onpremise_us    = module.step1-networking.vpc_id_onpremise_us
  vpc_id_aws_relay_eu    = module.step1-networking.vpc_id_aws_relay_eu
  vpc_id_aws_relay_us    = module.step1-networking.vpc_id_aws_relay_us
  vpc_id_aws_app         = module.step1-networking.vpc_id_aws_app
  ssm_role_profile       = module.step2-security.iam_role_profile_ec2_ssm
  keypair_name           = "onecloud"
}

module "step4-site2site-vpn" {
  depends_on                    = [module.step3-components]
  source                        = "./step4-site2site-vpn"
  prefix                        = local.prefix
  ip_cidr_onpremise_eu          = module.step1-networking.ip_cidr_onpremise_eu
  ip_cidr_onpremise_us          = module.step1-networking.ip_cidr_onpremise_us
  ip_cidr_relay_eu              = module.step1-networking.ip_cidr_relay_eu
  ip_cidr_relay_us              = module.step1-networking.ip_cidr_relay_us
  router_public_ip_onpremise_eu = module.step3-components.router_public_ip_onpremise_eu
  router_public_ip_onpremise_us = module.step3-components.router_public_ip_onpremise_us
  vpc_id_relay_eu               = module.step1-networking.vpc_id_aws_relay_eu
  vpc_id_relay_us               = module.step1-networking.vpc_id_aws_relay_us
  route_table_id_relay_eu       = module.step1-networking.route_table_id_relay_eu
  route_table_id_relay_us       = module.step1-networking.route_table_id_relay_us
  route_table_id_onpremise_eu   = module.step1-networking.route_table_id_onpremise_eu
  route_table_id_onpremise_us   = module.step1-networking.route_table_id_onpremise_us
  router_eni_id_onpremise_eu    = module.step3-components.router_eni_id_onpremise_eu
  router_eni_id_onpremise_us    = module.step3-components.router_eni_id_onpremise_us
}
