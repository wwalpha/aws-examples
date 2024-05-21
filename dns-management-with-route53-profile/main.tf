# ----------------------------------------------------------------------------------------------
# AWS Provider
# ----------------------------------------------------------------------------------------------
provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  backend "local" {
    path = "./tfstate/terraform.tfstate"
  }
}

# ----------------------------------------------------------------------------------------------
# Step1 Account Central DNS
# ----------------------------------------------------------------------------------------------
module "step1_account_central_dns" {
  source                                          = "./step1-account-central-dns"
  prefix                                          = local.prefix
  vpc_cidr_block                                  = local.vpc_cidr_block_central_dns
  subnets_cidr_block_public                       = local.subnets_cidr_block_public_central_dns
  subnets_cidr_block_private                      = local.subnets_cidr_block_private_central_dns
  availability_zones                              = local.availability_zones
  aws_domain_name                                 = var.aws_domain_name
  route53_resolver_inbound_endpoint_ip_addresses  = local.route53_resolver_inbound_endpoint_ip_addresses
  route53_resolver_outbound_endpoint_ip_addresses = local.route53_resolver_outbound_endpoint_ip_addresses
  onpremise_dns_server_ip                         = local.onpremise_dns_server_ip
}

# ----------------------------------------------------------------------------------------------
# Step2 Account Onpremise
# ----------------------------------------------------------------------------------------------
module "step2_account_onpremise" {
  depends_on                 = [module.step1_account_central_dns]
  source                     = "./step2-account-onpremise"
  prefix                     = local.prefix
  vpc_cidr_block             = local.vpc_cidr_block_onpremise
  subnets_cidr_block_public  = local.subnets_cidr_block_public_onpremise
  subnets_cidr_block_private = local.subnets_cidr_block_private_onpremise
  availability_zones         = local.availability_zones
  transit_gateway_id         = module.step1_account_central_dns.transit_gateway_id
  dns_server_ip              = local.onpremise_dns_server_ip
  ec2_keypair_name           = var.ec2_keypair_name
}

# ----------------------------------------------------------------------------------------------
# Step2 Account Workload App1
# ----------------------------------------------------------------------------------------------
module "step2_account_workload_app1" {
  depends_on                 = [module.step1_account_central_dns]
  source                     = "./step2-account-workload-app"
  prefix                     = "${local.prefix}-app1"
  vpc_id_central_dns         = module.step1_account_central_dns.vpc_id
  vpc_cidr_block             = local.vpc_cidr_block_workload_app1
  subnets_cidr_block_public  = local.subnets_cidr_block_public_workload_app1
  subnets_cidr_block_private = local.subnets_cidr_block_private_workload_app1
  alb_internal               = false
  availability_zones         = local.availability_zones
  domain_name                = "app1.${var.aws_domain_name}"
  transit_gateway_id         = module.step1_account_central_dns.transit_gateway_id
  ec2_keypair_name           = var.ec2_keypair_name
}

# ----------------------------------------------------------------------------------------------
# Step2 Account Workload App2
# ----------------------------------------------------------------------------------------------
module "step2_account_workload_app2" {
  depends_on                 = [module.step1_account_central_dns]
  source                     = "./step2-account-workload-app"
  prefix                     = "${local.prefix}-app2"
  vpc_id_central_dns         = module.step1_account_central_dns.vpc_id
  vpc_cidr_block             = local.vpc_cidr_block_workload_app2
  subnets_cidr_block_public  = local.subnets_cidr_block_public_workload_app2
  subnets_cidr_block_private = local.subnets_cidr_block_private_workload_app2
  alb_internal               = true
  availability_zones         = local.availability_zones
  domain_name                = "app2.${var.aws_domain_name}"
  transit_gateway_id         = module.step1_account_central_dns.transit_gateway_id
  ec2_keypair_name           = var.ec2_keypair_name
}

# ----------------------------------------------------------------------------------------------
# Step3 Account Central DNS
# ----------------------------------------------------------------------------------------------
module "step3_account_central_dns" {
  depends_on                                  = [module.step2_account_onpremise, module.step2_account_workload_app1, module.step2_account_workload_app2]
  source                                      = "./step3-account-central-dns"
  prefix                                      = local.prefix
  transit_gateway_id                          = module.step1_account_central_dns.transit_gateway_id
  transit_gateway_attachment_id_central_dns   = module.step1_account_central_dns.transit_gateway_attachment_id
  transit_gateway_attachment_id_onpremise     = module.step2_account_onpremise.transit_gateway_attachment_id
  transit_gateway_attachment_id_workload_app1 = module.step2_account_workload_app1.transit_gateway_attachment_id
  transit_gateway_attachment_id_workload_app2 = module.step2_account_workload_app2.transit_gateway_attachment_id
  vpc_id_central_dns                          = module.step1_account_central_dns.vpc_id
  vpc_id_onpremise                            = module.step2_account_onpremise.vpc_id
  vpc_id_app1                                 = module.step2_account_workload_app1.vpc_id
  vpc_id_app2                                 = module.step2_account_workload_app2.vpc_id
  vpc_cidr_block_central_dns                  = local.vpc_cidr_block_central_dns
  vpc_cidr_block_onpremise                    = local.vpc_cidr_block_onpremise
  vpc_cidr_block_app1                         = local.vpc_cidr_block_workload_app1
  vpc_cidr_block_app2                         = local.vpc_cidr_block_workload_app2
  alb_dns_name_app1                           = module.step2_account_workload_app1.alb_dns_name
  alb_dns_name_app2                           = module.step2_account_workload_app2.alb_dns_name
  alb_zone_id_app1                            = module.step2_account_workload_app1.alb_zone_id
  alb_zone_id_app2                            = module.step2_account_workload_app2.alb_zone_id
  aws_domain_name                             = var.aws_domain_name
}

# ----------------------------------------------------------------------------------------------
# Step4 Account Central DNS - Transit Gateway Routing
# ----------------------------------------------------------------------------------------------
module "step4_account_central_dns" {
  depends_on         = [module.step3_account_central_dns]
  source             = "./commons-addroute"
  route_table_ids    = module.step1_account_central_dns.vpc_private_route_table_ids
  transit_gateway_id = module.step1_account_central_dns.transit_gateway_id
}

# ----------------------------------------------------------------------------------------------
# Step4 Account Onpremise - Transit Gateway Routing
# ----------------------------------------------------------------------------------------------
module "step4_account_onpremise" {
  depends_on         = [module.step3_account_central_dns]
  source             = "./commons-addroute"
  route_table_ids    = module.step2_account_onpremise.vpc_private_route_table_ids
  transit_gateway_id = module.step1_account_central_dns.transit_gateway_id
}

# ----------------------------------------------------------------------------------------------
# Step4 Account Workload App1 - Transit Gateway Routing
# ----------------------------------------------------------------------------------------------
module "step4_account_app1" {
  depends_on         = [module.step3_account_central_dns]
  source             = "./commons-addroute"
  route_table_ids    = module.step2_account_workload_app1.vpc_private_route_table_ids
  transit_gateway_id = module.step1_account_central_dns.transit_gateway_id
}

# ----------------------------------------------------------------------------------------------
# Step4 Account Workload App2 - Transit Gateway Routing
# ----------------------------------------------------------------------------------------------
module "step4_account_app2" {
  depends_on         = [module.step3_account_central_dns]
  source             = "./commons-addroute"
  route_table_ids    = module.step2_account_workload_app2.vpc_private_route_table_ids
  transit_gateway_id = module.step1_account_central_dns.transit_gateway_id
}
