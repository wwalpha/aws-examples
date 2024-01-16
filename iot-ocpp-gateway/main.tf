
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
  vpc_private_subnet_ids      = module.step2-network.vpc_private_subnet_ids
  vpc_cidr_block              = module.step2-network.vpc_cidr_block
  ecs_task_role_arn           = module.step1-security.ecs_task_role_arn
  ecs_execution_role_arn      = module.step1-security.ecs_task_execution_role_arn
  dynamodb_table_charge_point = module.step3-database.dynamodb_table_charge_point
}

module "step5-iot" {
  source                                       = "./step5-iot"
  prefix                                       = local.prefix
  dynamodb_table_charge_point                  = module.step3-database.dynamodb_table_charge_point
  iot_rule_create_thing_role_arn               = module.step1-security.iot_rule_create_thing_role_arn
  iot_rule_message_from_charge_points_role_arn = module.step1-security.iot_rule_message_from_charge_points_role_arn
}
