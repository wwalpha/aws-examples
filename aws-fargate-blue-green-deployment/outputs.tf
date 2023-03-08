# output "private_subnets_cidr_block" {
#   value = module.networking.private_subnets_cidr_blocks
# }

# output "aws_db_proxy_endpoint" {
#   value = module.database.aws_rds_proxy.endpoint
# }

# output "aws_db_endpoint" {
#   value = module.database.aws_rds_instance.address
# }

# output "aws_db_instance_id" {
#   value = module.database.aws_rds_instance.id
# }

output "app_url" {
  value = "http://${module.app.alb_dns_name}/"
}

output "ecs_cluster_name" {
  value = module.app.ecs_cluster_name
}

output "ecs_service_name" {
  value = module.app.ecs_service_name
}

output "ecs_task_definition_arn" {
  value = module.app.ecs_task_definition_arn
}

output "codedeploy_application" {
  value = module.devops.codedeploy_application
}
