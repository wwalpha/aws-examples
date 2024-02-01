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

# module "security" {
#   source = "./step2-security"
#   prefix = local.prefix
# }

# module "app" {
#   depends_on           = [module.networking]
#   source               = "./app"
#   vpc_id               = module.networking.vpc_id
#   public_subnets       = module.networking.public_subnets[*].id
#   private_subnets      = module.networking.private_subnets[*].id
#   ec2_ssm_role_profile = module.security.ec2_ssm_role_profile.name
# }
