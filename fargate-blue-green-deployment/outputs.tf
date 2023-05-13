# ----------------------------------------------------------------------------------------------
# Application Load Balancer URL
# ----------------------------------------------------------------------------------------------
output "app_url" {
  value = "http://${module.app.alb_dns_name}/"
}

# ----------------------------------------------------------------------------------------------
# ECS Cluster Name
# ----------------------------------------------------------------------------------------------
output "ecs_cluster_name" {
  value = module.app.ecs_cluster_name
}

# ----------------------------------------------------------------------------------------------
# ECS Service Name
# ----------------------------------------------------------------------------------------------
output "ecs_service_name" {
  value = module.app.ecs_service_name
}

# ----------------------------------------------------------------------------------------------
# ECS Task Definition Name
# ----------------------------------------------------------------------------------------------
output "ecs_task_definition_name" {
  value = module.app.ecs_task_definition_name
}

# ----------------------------------------------------------------------------------------------
# Code Deploy Application
# ----------------------------------------------------------------------------------------------
output "codedeploy_application" {
  value = module.devops.codedeploy_application
}

# ----------------------------------------------------------------------------------------------
# Code Deploy Deployment Group Name
# ----------------------------------------------------------------------------------------------
output "codedeploy_deployment_group_name" {
  value = module.devops.codedeploy_deployment_group_name
}

# ----------------------------------------------------------------------------------------------
# S3 Location - AppSpec
# ----------------------------------------------------------------------------------------------
output "appspec_s3_location" {
  value = module.storage.appspec_s3_location
}