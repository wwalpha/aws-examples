# ----------------------------------------------------------------------------------------------
# AWS Provider
# ----------------------------------------------------------------------------------------------
provider "aws" {
}

# ----------------------------------------------------------------------------------------------
# Terraform Settings
# ----------------------------------------------------------------------------------------------
terraform {
  backend "local" {
    path = "./main.tfstate"
  }
}

locals {
  cross_account_id     = "999999999999"
  cross_account_vpc_id = "vpc-xxxxxxxxxxxxxxxxxx"
}

module "system" {
  source                          = "./modules"
  env_name                        = "system"
  cross_account_id                = local.cross_account_id
  vpc_id                          = module.networking.vpc_id
  public_subnets                  = module.networking.public_subnets
  private_subnets                 = module.networking.private_subnets
  rds_db_subnet_group_name        = module.database.db_subnet_group_name
  rds_db_parameter_group_name     = module.database.db_parameter_group_name
  sg_client_vpn                   = module.networking.sg_id_client_vpn
  sg_vpc_endpoint                 = module.networking.sg_id_vpc_endpoint
  enable_autoscaling_group_proxy  = false
  enable_autoscaling_group_app    = false
  rds_app_multi_az                = false
  rds_batch_count                 = 1
  rds_backup_retention_period_app = 1
}
