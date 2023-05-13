# ----------------------------------------------------------------------------------------------
# ECS Cluster Name
# ----------------------------------------------------------------------------------------------
output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

# ----------------------------------------------------------------------------------------------
# ECS Service Name
# ----------------------------------------------------------------------------------------------
output "ecs_service_name" {
  value = aws_ecs_service.this.name
}

# ----------------------------------------------------------------------------------------------
# ECS Task Definition Arn
# ----------------------------------------------------------------------------------------------
output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.this.arn
}

# ----------------------------------------------------------------------------------------------
# ECS Task Definition Name
# ----------------------------------------------------------------------------------------------
output "ecs_task_definition_name" {
  value = aws_ecs_task_definition.this.family
}

# ----------------------------------------------------------------------------------------------
# Load Balancer Listener Arn for Production
# ----------------------------------------------------------------------------------------------
output "lb_listener_arn_prod" {
  value = aws_lb_listener.production.arn
}

# ----------------------------------------------------------------------------------------------
# Load Balancer Listener Arn for Test
# ----------------------------------------------------------------------------------------------
output "lb_listener_arn_test" {
  value = aws_lb_listener.test.arn
}

# ----------------------------------------------------------------------------------------------
# Load Balancer Target Group Name - Blue
# ----------------------------------------------------------------------------------------------
output "lb_target_group_blue_name" {
  value = aws_lb_target_group.blue.name
}

# ----------------------------------------------------------------------------------------------
# Load Balancer Target Group Name - Green
# ----------------------------------------------------------------------------------------------
output "lb_target_group_green_name" {
  value = aws_lb_target_group.green.name
}

# ----------------------------------------------------------------------------------------------
# Load Balancer DNS Name
# ----------------------------------------------------------------------------------------------
output "alb_dns_name" {
  value = aws_lb.this.dns_name
}