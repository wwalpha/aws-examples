# ----------------------------------------------------------------------------------------------
# AWS Provider - Central DNS (SharedService Stage)
# ----------------------------------------------------------------------------------------------
provider "aws" {
  region = "ap-northeast-1"
  alias  = "SharedService"

  assume_role {
    role_arn = "arn:aws:iam::${local.account_central_dns}:role/TestingMultiAccountRole"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Provider - Onpremise (Logging Stage)
# ----------------------------------------------------------------------------------------------
provider "aws" {
  region = "ap-northeast-1"
  alias  = "Onpremise"

  assume_role {
    role_arn = "arn:aws:iam::${local.account_onpremise}:role/TestingMultiAccountRole"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Provider - Workload public (Network Dev)
# ----------------------------------------------------------------------------------------------
provider "aws" {
  region = "ap-northeast-1"
  alias  = "WorkloadPublic"

  assume_role {
    role_arn = "arn:aws:iam::${local.account_app1}:role/TestingMultiAccountRole"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Provider - Workload private (Sandbox)
# ----------------------------------------------------------------------------------------------
provider "aws" {
  region = "ap-northeast-1"
  alias  = "WorkloadPrivate"
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
  providers = {
    aws = aws.SharedService
  }

  source                                          = "./step1-account-central-dns"
  prefix                                          = local.prefix
  vpc_cidr_block                                  = local.vpc_cidr_block_central_dns
  subnets_cidr_block_public                       = local.subnets_cidr_block_public_central_dns
  subnets_cidr_block_private                      = local.subnets_cidr_block_private_central_dns
  availability_zones                              = local.availability_zones
  cloud_domain_name                               = local.aws_domain_name
  route53_resolver_inbound_endpoint_ip_addresses  = local.route53_resolver_inbound_endpoint_ip_addresses
  route53_resolver_outbound_endpoint_ip_addresses = local.route53_resolver_outbound_endpoint_ip_addresses
  onpremise_dns_server_ip                         = local.onpremise_dns_server_ip
  principal_accounts = [
    # cannot be shared with the owning account
    # local.account_central_dns,
    local.account_onpremise,
    var.aws_account_id_workload_app1,
    local.account_app2
  ]
}

# ----------------------------------------------------------------------------------------------
# Step2 Account Onpremise
# ----------------------------------------------------------------------------------------------
module "step2_account_onpremise" {
  providers = {
    aws = aws.Onpremise
  }

  depends_on                    = [module.step1_account_central_dns]
  source                        = "./step2-account-onpremise"
  prefix                        = local.prefix
  vpc_cidr_block                = local.vpc_cidr_block_onpremise
  subnets_cidr_block_public     = local.subnets_cidr_block_public_onpremise
  subnets_cidr_block_private    = local.subnets_cidr_block_private_onpremise
  availability_zones            = local.availability_zones
  ram_share_arn_transit_gateway = module.step1_account_central_dns.ram_share_arn_transit_gateway[local.account_onpremise].resource_share_arn
  transit_gateway_id            = module.step1_account_central_dns.transit_gateway_id
}

# ----------------------------------------------------------------------------------------------
# Step2 Account Workload App1
# ----------------------------------------------------------------------------------------------
module "step2_account_workload_app1" {
  providers = {
    aws = aws.WorkloadPublic
  }

  depends_on                               = [module.step1_account_central_dns]
  source                                   = "./step2-account-workload-app"
  prefix                                   = "${local.prefix}-app1"
  vpc_id_central_dns                       = module.step1_account_central_dns.vpc_id
  vpc_cidr_block                           = local.vpc_cidr_block_workload_app1
  subnets_cidr_block_public                = local.subnets_cidr_block_public_workload_app1
  subnets_cidr_block_private               = local.subnets_cidr_block_private_workload_app1
  alb_internal                             = false
  availability_zones                       = local.availability_zones
  domain_name                              = "app1.${local.aws_domain_name}"
  ram_share_arn_transit_gateway            = module.step1_account_central_dns.ram_share_arn_transit_gateway[local.account_app1].resource_share_arn
  ram_share_arn_resolver_forward_onpremise = module.step1_account_central_dns.ram_share_arn_resolver_forward_onpremise[local.account_app1].resource_share_arn
  ram_share_arn_resolver_forward_cloud     = module.step1_account_central_dns.ram_share_arn_resolver_forward_cloud[local.account_app1].resource_share_arn
  ram_share_arn_resolver_system            = module.step1_account_central_dns.ram_share_arn_resolver_system[local.account_app1].resource_share_arn
  transit_gateway_id                       = module.step1_account_central_dns.transit_gateway_id
  resolver_rule_id_forward_onpremise       = module.step1_account_central_dns.resolver_rule_id_forward_onpremise
  resolver_rule_id_forward_cloud           = module.step1_account_central_dns.resolver_rule_id_forward_cloud
  resolver_rule_id_system                  = module.step1_account_central_dns.resolver_rule_id_system
}

# ----------------------------------------------------------------------------------------------
# Step2 Account Workload App2
# ----------------------------------------------------------------------------------------------
module "step2_account_workload_app2" {
  depends_on                               = [module.step1_account_central_dns]
  source                                   = "./step2-account-workload-app"
  prefix                                   = "${local.prefix}-app2"
  vpc_id_central_dns                       = module.step1_account_central_dns.vpc_id
  vpc_cidr_block                           = local.vpc_cidr_block_workload_app2
  subnets_cidr_block_public                = local.subnets_cidr_block_public_workload_app2
  subnets_cidr_block_private               = local.subnets_cidr_block_private_workload_app2
  alb_internal                             = true
  availability_zones                       = local.availability_zones
  domain_name                              = "app2.${local.aws_domain_name}"
  ram_share_arn_transit_gateway            = module.step1_account_central_dns.ram_share_arn_transit_gateway[local.account_app2].resource_share_arn
  ram_share_arn_resolver_forward_onpremise = module.step1_account_central_dns.ram_share_arn_resolver_forward_onpremise[local.account_app2].resource_share_arn
  ram_share_arn_resolver_forward_cloud     = module.step1_account_central_dns.ram_share_arn_resolver_forward_cloud[local.account_app2].resource_share_arn
  ram_share_arn_resolver_system            = module.step1_account_central_dns.ram_share_arn_resolver_system[local.account_app2].resource_share_arn
  transit_gateway_id                       = module.step1_account_central_dns.transit_gateway_id
  resolver_rule_id_forward_onpremise       = module.step1_account_central_dns.resolver_rule_id_forward_onpremise
  resolver_rule_id_forward_cloud           = module.step1_account_central_dns.resolver_rule_id_forward_cloud
  resolver_rule_id_system                  = module.step1_account_central_dns.resolver_rule_id_system
}

# ----------------------------------------------------------------------------------------------
# Step3 Account Central DNS
# ----------------------------------------------------------------------------------------------
module "step3_account_central_dns" {
  providers = {
    aws = aws.SharedService
  }

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
  hosted_zone_id_app1                         = module.step2_account_workload_app1.hosted_zone_id
  hosted_zone_id_app2                         = module.step2_account_workload_app2.hosted_zone_id
  domain_name                                 = local.aws_domain_name
}

# data "aws_ram_resource_share" "example" {
#   provider       = aws.Onpremise
#   name           = "resolver_resolver_rules"
#   resource_owner = "OTHER-ACCOUNTS"
# }

# data "aws_route53_resolver_rule" "example" {
#   name = "resolver_resolver_rules"
# }

# module "networking" {
#   source                     = "./commons-networking"
#   prefix                     = local.prefix
#   vpc_cidr_block             = local.vpc_cidr_block_workload_app1
#   subnets_cidr_block_public  = local.subnets_cidr_block_public_workload_app1
#   subnets_cidr_block_private = local.subnets_cidr_block_private_workload_app1
#   availability_zones         = local.availability_zones
#   # transit_gateway_id         = module.step1_account_central_dns.transit_gateway_id
# }
