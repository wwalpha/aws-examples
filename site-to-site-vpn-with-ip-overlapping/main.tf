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
  subnet_id_onpremise_jp = module.step1-networking.subnet_id_onpremise_jp
  subnet_id_aws_relay_eu = module.step1-networking.subnet_id_aws_relay_eu
  subnet_id_aws_relay_us = module.step1-networking.subnet_id_aws_relay_us
  subnet_id_aws_relay_jp = module.step1-networking.subnet_id_aws_relay_jp
  subnet_id_aws_app      = module.step1-networking.subnet_id_aws_app
  vpc_id_onpremise_eu    = module.step1-networking.vpc_id_onpremise_eu
  vpc_id_onpremise_us    = module.step1-networking.vpc_id_onpremise_us
  vpc_id_onpremise_jp    = module.step1-networking.vpc_id_onpremise_jp
  vpc_id_aws_relay_eu    = module.step1-networking.vpc_id_aws_relay_eu
  vpc_id_aws_relay_us    = module.step1-networking.vpc_id_aws_relay_us
  vpc_id_aws_relay_jp    = module.step1-networking.vpc_id_aws_relay_jp
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
  ip_cidr_onpremise_jp          = module.step1-networking.ip_cidr_onpremise_jp
  ip_cidr_relay_eu              = module.step1-networking.ip_cidr_relay_eu
  ip_cidr_relay_us              = module.step1-networking.ip_cidr_relay_us
  ip_cidr_relay_jp              = module.step1-networking.ip_cidr_relay_jp
  router_public_ip_onpremise_eu = module.step3-components.router_public_ip_onpremise_eu
  router_public_ip_onpremise_us = module.step3-components.router_public_ip_onpremise_us
  router_public_ip_onpremise_jp = module.step3-components.router_public_ip_onpremise_jp
  vpc_id_relay_eu               = module.step1-networking.vpc_id_aws_relay_eu
  vpc_id_relay_us               = module.step1-networking.vpc_id_aws_relay_us
  vpc_id_relay_jp               = module.step1-networking.vpc_id_aws_relay_jp
  route_table_id_relay_eu       = module.step1-networking.route_table_id_relay_eu
  route_table_id_relay_us       = module.step1-networking.route_table_id_relay_us
  route_table_id_relay_jp       = module.step1-networking.route_table_id_relay_jp
  route_table_id_onpremise_eu   = module.step1-networking.route_table_id_onpremise_eu
  route_table_id_onpremise_us   = module.step1-networking.route_table_id_onpremise_us
  route_table_id_onpremise_jp   = module.step1-networking.route_table_id_onpremise_jp
  router_eni_id_eu              = module.step3-components.router_eni_id_eu
  router_eni_id_us              = module.step3-components.router_eni_id_us
  router_eni_id_jp              = module.step3-components.router_eni_id_jp
}

module "step5-prepare" {
  depends_on             = [module.step4-site2site-vpn]
  source                 = "./step5-prepare"
  prefix                 = local.prefix
  tunnel_address_eu      = module.step4-site2site-vpn.tunnel_address_eu
  tunnel_address_us      = module.step4-site2site-vpn.tunnel_address_us
  tunnel_address_jp      = module.step4-site2site-vpn.tunnel_address_jp
  s2s_psk_key_eu         = module.step4-site2site-vpn.s2s_psk_key_eu
  s2s_psk_key_us         = module.step4-site2site-vpn.s2s_psk_key_us
  s2s_psk_key_jp         = module.step4-site2site-vpn.s2s_psk_key_jp
  instance_id_router_eu  = module.step3-components.instance_id_router_eu
  instance_id_router_us  = module.step3-components.instance_id_router_us
  instance_id_router_jp  = module.step3-components.instance_id_router_jp
  ipv4_cidr_onpremise_eu = module.step1-networking.ip_cidr_onpremise_eu
  ipv4_cidr_aws_eu       = module.step1-networking.ip_cidr_relay_eu
  ipv4_cidr_onpremise_us = module.step1-networking.ip_cidr_onpremise_us
  ipv4_cidr_aws_us       = module.step1-networking.ip_cidr_relay_us
  ipv4_cidr_onpremise_jp = module.step1-networking.ip_cidr_onpremise_jp
  ipv4_cidr_aws_jp       = module.step1-networking.ip_cidr_relay_jp
}

data "aws_instance" "router" {
  instance_id = module.step3-components.instance_id_router_eu
}
