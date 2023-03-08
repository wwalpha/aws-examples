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

# module "database" {
#   source                    = "./database"
#   prefix                    = local.prefix
#   vpc_id                    = module.networking.vpc_id
#   private_subnet_cidr_block = module.networking.private_subnets_cidr_blocks
#   private_subnet_ids        = module.networking.private_subnet_ids
#   database_subnet_ids       = module.networking.database_subnet_ids
#   database_username         = var.database_username
#   database_password         = var.database_password
#   iam_role_arn_rds_proxy    = module.security.iam_role_arn_rds_proxy
# }

module "app" {
  source                 = "./app"
  prefix                 = local.prefix
  vpc_id                 = module.networking.vpc_id
  public_subnet_ids      = module.networking.public_subnet_ids
  ecs_task_role_arn      = module.security.iam_role_arn_ecs_task
  ecs_task_exec_role_arn = module.security.iam_role_arn_ecs_task_exec
  environment            = var.environment
}

module "devops" {
  source                     = "./devops"
  prefix                     = local.prefix
  codedeploy_role_arn        = module.security.iam_role_arn_code_deploy
  ecs_cluster_name           = module.app.ecs_cluster_name
  ecs_service_name           = module.app.ecs_service_name
  lb_listener_arn_prod       = module.app.lb_listener_arn_prod
  lb_listener_arn_test       = module.app.lb_listener_arn_test
  lb_target_group_blue_name  = module.app.lb_target_group_blue_name
  lb_target_group_green_name = module.app.lb_target_group_green_name
}
