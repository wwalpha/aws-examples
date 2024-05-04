# ----------------------------------------------------------------------------------------------
# AWS Provider - Shared Service (SharedService Stage)
# ----------------------------------------------------------------------------------------------
provider "aws" {
  region = "ap-northeast-1"
  alias  = "SharedService"

  assume_role {
    role_arn = "arn:aws:iam::${local.aws_account_id_central_dns}:role/TestingMultiAccountRole"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Provider - Onpremise (Logging Stage)
# ----------------------------------------------------------------------------------------------
provider "aws" {
  region = "ap-northeast-1"
  alias  = "Onpremise"

  assume_role {
    role_arn = "arn:aws:iam::${local.aws_account_id_onpremise}:role/TestingMultiAccountRole"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Provider - Workload public (Network Dev)
# ----------------------------------------------------------------------------------------------
provider "aws" {
  region = "ap-northeast-1"
  alias  = "WorkloadPublic"

  assume_role {
    role_arn = "arn:aws:iam::${local.aws_account_id_workload_app1}:role/TestingMultiAccountRole"
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
# Networking Commons Before
# ----------------------------------------------------------------------------------------------
module "step1_networking_commons_before" {
  providers = {
    aws = aws.SharedService
  }

  depends_on                   = [aws_ec2_transit_gateway.this]
  source                       = "./step1-networking-commons-before"
  prefix                       = local.prefix
  aws_account_id_central_dns   = local.aws_account_id_central_dns
  aws_account_id_onpremise     = local.aws_account_id_onpremise
  aws_account_id_workload_app1 = local.aws_account_id_workload_app1
  aws_account_id_workload_app2 = local.aws_account_id_workload_app2
}

# ----------------------------------------------------------------------------------------------
# Networking Central DNS
# ----------------------------------------------------------------------------------------------
module "networking_central_dns" {
  providers = {
    aws = aws.SharedService
  }

  depends_on                 = [module.step1_networking_commons_before]
  source                     = "./step1-networking"
  prefix                     = local.prefix
  vpc_cidr_block             = local.vpc_cidr_block_central_dns
  subnets_cidr_block_public  = local.subnets_cidr_block_public_central_dns
  subnets_cidr_block_private = local.subnets_cidr_block_private_central_dns
  availability_zones         = local.availability_zones
  transit_gateway_id         = module.step1_networking_commons_before.transit_gateway_id
  ram_resource_share_arn     = module.step1_networking_commons_before.ram_resource_share_arn
}

# ----------------------------------------------------------------------------------------------
# Networking Onpremise
# ----------------------------------------------------------------------------------------------
module "networking_onpremise" {
  providers = {
    aws = aws.Onpremise
  }

  depends_on                 = [module.step1_networking_commons_before]
  source                     = "./step1-networking"
  prefix                     = local.prefix
  vpc_cidr_block             = local.vpc_cidr_block_onpremise
  subnets_cidr_block_public  = local.subnets_cidr_block_public_onpremise
  subnets_cidr_block_private = local.subnets_cidr_block_private_onpremise
  availability_zones         = local.availability_zones
  transit_gateway_id         = module.step1_networking_commons_before.transit_gateway_id
  ram_resource_share_arn     = module.step1_networking_commons_before.ram_resource_share_arn
}

# ----------------------------------------------------------------------------------------------
# Networking Workload App1
# ----------------------------------------------------------------------------------------------
module "networking_workload_app1" {
  providers = {
    aws = aws.WorkloadPublic
  }

  depends_on                 = [module.step1_networking_commons_before]
  source                     = "./step1-networking"
  prefix                     = local.prefix
  vpc_cidr_block             = local.vpc_cidr_block_onpremise
  subnets_cidr_block_public  = local.subnets_cidr_block_public_workload_app1
  subnets_cidr_block_private = local.subnets_cidr_block_private_workload_app1
  availability_zones         = local.availability_zones
  transit_gateway_id         = module.step1_networking_commons_before.transit_gateway_id
  ram_resource_share_arn     = module.step1_networking_commons_before.ram_resource_share_arn
}

# ----------------------------------------------------------------------------------------------
# Networking Workload App2
# ----------------------------------------------------------------------------------------------
module "networking_workload_app2" {
  depends_on                 = [module.step1_networking_commons_before]
  source                     = "./step1-networking"
  prefix                     = local.prefix
  vpc_cidr_block             = local.vpc_cidr_block_onpremise
  subnets_cidr_block_public  = local.subnets_cidr_block_public_workload_app2
  subnets_cidr_block_private = local.subnets_cidr_block_private_workload_app2
  availability_zones         = local.availability_zones
  transit_gateway_id         = module.step1_networking_commons_before.transit_gateway_id
  ram_resource_share_arn     = module.step1_networking_commons_before.ram_resource_share_arn
}

# module "networking_workload" {
#   source = "./step1-networking-workload"
#   prefix = local.prefix
# }

# module "security" {
#   providers = {
#     aws = aws.SharedService
#   }

#   source = "./step2-security"
#   prefix = local.prefix
# }

# module "app" {
#   providers = {
#     aws = aws.SharedService
#   }

#   depends_on            = [module.networking_shared, module.networking_workload]
#   source                = "./step3-app"
#   prefix                = local.prefix
#   ec2_ssm_role_name     = module.security.ec2_ssm_role.name
#   ec2_keypair_name      = "resolver-testing"
#   vpc_id_onpremise      = module.networking_shared.vpc_id_onpremise
#   vpc_subnets_onpremise = module.networking_shared.vpc_subnets_onpremise
#   # vpc_id_workload_intra              = module.networking.vpc_id_workload_intra
#   # vpc_id_workload_web                = module.networking.vpc_id_workload_web
#   # vpc_id_ingress                     = module.networking.vpc_id_ingress
#   # vpc_subnets_workload_intra_private = module.networking.vpc_subnets_workload_intra_private
#   # vpc_subnets_workload_web_public    = module.networking.vpc_subnets_workload_web_public
#   # vpc_subnets_workload_web_private   = module.networking.vpc_subnets_workload_web_private
#   # vpc_subnets_ingress_public         = module.networking.vpc_subnets_ingress_public
# }
