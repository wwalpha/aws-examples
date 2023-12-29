
# ----------------------------------------------------------------------------------------------
# AWS Provider
# ----------------------------------------------------------------------------------------------
provider "aws" {}

terraform {
  backend "local" {
    path = "./tfstate/terraform.tfstate"
  }
}

module "step1-security" {
  source = "./step1-security"
  prefix = local.prefix
}

module "step2-network" {
  source = "./step2-network"
  prefix = local.prefix
}

module "step3-database" {
  source = "./step3-database"
  prefix = local.prefix
}

module "step4-app" {
  source                      = "./step4-app"
  prefix                      = local.prefix
  vpc_id                      = module.step2-network.vpc_id
  vpc_public_subnet_ids       = module.step2-network.vpc_public_subnet_ids
  ecs_task_role_arn           = module.step1-security.ecs_task_role_arn
  ecs_execution_role_arn      = module.step1-security.ecs_task_execution_role_arn
  dynamodb_table_charge_point = module.step3-database.dynamodb_table_charge_point
}
