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
  depends_on = [module.step1-networking]
  source     = "./step2-security"
  prefix     = local.prefix
}

module "step3-components" {
  depends_on            = [module.step2-security]
  source                = "./step3-components"
  prefix                = local.prefix
  subnet_id_onpremise_a = module.step1-networking.subnet_id_onpremise_a
  subnet_id_onpremise_b = module.step1-networking.subnet_id_onpremise_b
  subnet_id_aws_relay_a = module.step1-networking.subnet_id_aws_relay_a
  subnet_id_aws_relay_b = module.step1-networking.subnet_id_aws_relay_b
  subnet_id_aws_app     = module.step1-networking.subnet_id_aws_app
  vpc_id_onpremise_a    = module.step1-networking.vpc_id_onpremise_a
  vpc_id_onpremise_b    = module.step1-networking.vpc_id_onpremise_b
  vpc_id_aws_relay_a    = module.step1-networking.vpc_id_aws_relay_a
  vpc_id_aws_relay_b    = module.step1-networking.vpc_id_aws_relay_b
  vpc_id_aws_app        = module.step1-networking.vpc_id_aws_app
  ssm_role_profile      = module.step2-security.iam_role_profile_ec2_ssm
  keypair_name          = "onecloud"
}

module "step4-site2site-vpn" {
  depends_on                    = [module.step3-components]
  source                        = "./step4-site2site-vpn"
  prefix                        = local.prefix
  ip_cidr_onpremise_eu          = module.step1-networking.ip_cidr_onpremise_a
  ip_cidr_onpremise_us          = module.step1-networking.ip_cidr_onpremise_b
  ip_cidr_relay_eu              = module.step1-networking.ip_cidr_aws_relay_a
  ip_cidr_relay_us              = module.step1-networking.ip_cidr_aws_relay_b
  router_public_ip_onpremise_eu = module.step1-networking.router_public_ip_onpremise_eu
  router_public_ip_onpremise_us = module.step1-networking.router_public_ip_onpremise_us
  vpc_id_relay_eu               = module.step1-networking.vpc_id_aws_relay_a
  vpc_id_relay_us               = module.step1-networking.vpc_id_aws_relay_b

}
