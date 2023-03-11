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
  source = "./networking"
  prefix = local.prefix
}

module "security" {
  source = "./security"
  prefix = local.prefix
}

module "database" {
  source                    = "./database"
  prefix                    = local.prefix
  vpc_id                    = module.networking.vpc_id
  private_subnet_cidr_block = module.networking.private_subnets_cidr_blocks
  private_subnet_ids        = module.networking.private_subnet_ids
  database_subnet_ids       = module.networking.database_subnet_ids
  database_username         = var.database_username
  database_password         = var.database_password
  iam_role_arn_rds_proxy    = module.security.iam_role_arn_rds_proxy
}

module "app" {
  source                    = "./app"
  prefix                    = local.prefix
  vpc_id                    = module.networking.vpc_id
  public_subnets            = module.networking.public_subnet_ids
  private_subnets           = module.networking.private_subnet_ids
  private_subnet_cidr_block = module.networking.private_subnets_cidr_blocks
  iam_role_profile_ec2_ssm  = module.security.iam_role_profile_ec2_ssm
  database_proxy_sg_id      = module.database.aws_rds_proxy_sg.id
  database_proxy_endpoint   = module.database.aws_rds_proxy.endpoint
  database_username         = var.database_username
  database_password         = var.database_password
}
