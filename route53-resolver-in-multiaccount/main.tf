# ----------------------------------------------------------------------------------------------
# AWS Provider
# ----------------------------------------------------------------------------------------------
provider "aws" {
  region = "ap-northeast-1"
  alias  = "SharedService"

  assume_role {
    role_arn = "arn:aws:iam::654654245439:role/TestingMultiAccountRole"
  }
}

terraform {
  backend "local" {
    path = "./tfstate/terraform.tfstate"
  }
}

module "networking_shared" {
  providers = {
    aws = aws.SharedService
  }

  source = "./step1-networking-shared"
  prefix = local.prefix
}

module "networking_workload" {
  source = "./step1-networking-workload"
  prefix = local.prefix
}

module "security" {
  providers = {
    aws = aws.SharedService
  }

  source = "./step2-security"
  prefix = local.prefix
}

module "app" {
  providers = {
    aws = aws.SharedService
  }

  depends_on            = [module.networking_shared, module.networking_workload]
  source                = "./step3-app"
  prefix                = local.prefix
  ec2_ssm_role_name     = module.security.ec2_ssm_role.name
  ec2_keypair_name      = "resolver-testing"
  vpc_id_onpremise      = module.networking_shared.vpc_id_onpremise
  vpc_subnets_onpremise = module.networking_shared.vpc_subnets_onpremise
  # vpc_id_workload_intra              = module.networking.vpc_id_workload_intra
  # vpc_id_workload_web                = module.networking.vpc_id_workload_web
  # vpc_id_ingress                     = module.networking.vpc_id_ingress
  # vpc_subnets_workload_intra_private = module.networking.vpc_subnets_workload_intra_private
  # vpc_subnets_workload_web_public    = module.networking.vpc_subnets_workload_web_public
  # vpc_subnets_workload_web_private   = module.networking.vpc_subnets_workload_web_private
  # vpc_subnets_ingress_public         = module.networking.vpc_subnets_ingress_public
}
