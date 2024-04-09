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
  depends_on                    = [module.networking]
  source                        = "./step3-app"
  prefix                        = local.prefix
  ec2_ssm_role_name             = module.security.ec2_ssm_role.name
  vpc_id_onpremise              = module.networking.vpc_id_onpremise
  vpc_subnets_onpremise_private = module.networking.vpc_subnets_onpremise_private
  # vpc_id_workload_intra              = module.networking.vpc_id_workload_intra
  # vpc_id_workload_web                = module.networking.vpc_id_workload_web
  # vpc_id_ingress                     = module.networking.vpc_id_ingress
  # vpc_subnets_workload_intra_private = module.networking.vpc_subnets_workload_intra_private
  # vpc_subnets_workload_web_public    = module.networking.vpc_subnets_workload_web_public
  # vpc_subnets_workload_web_private   = module.networking.vpc_subnets_workload_web_private
  # vpc_subnets_ingress_public         = module.networking.vpc_subnets_ingress_public
}
