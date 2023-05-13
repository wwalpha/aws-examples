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
  source                     = "./networking"
  prefix                     = local.prefix
  availability_zones         = local.availability_zones
  vpc_cidr_block             = local.vpc_cidr_block
  private_subnets_cidr_block = local.private_subnets_cidr_block
  public_subnets_cidr_block  = local.public_subnets_cidr_block
}

module "security" {
  source                 = "./security"
  prefix                 = local.prefix
  vpc_id                 = module.networking.vpc_id
  vpc_private_subnet_ids = module.networking.vpc_private_subnet_ids
}

module "app" {
  source                 = "./app"
  prefix                 = local.prefix
  vpc_id                 = module.networking.vpc_id
  vpc_private_subnet_ids = module.networking.vpc_private_subnet_ids
  iam_role_arn_adminad   = module.security.iam_role_arn_adadmin
  ami_id_windows         = var.ami_id_windows
  ds_directory_id        = module.security.ds_directory_id
}
