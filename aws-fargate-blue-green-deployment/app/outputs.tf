output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "ecs_service_name" {
  value = aws_ecs_service.this.name
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.this.arn
}

output "lb_listener_arn_prod" {
  value = aws_lb_listener.production.arn
}

output "lb_listener_arn_test" {
  value = aws_lb_listener.test.arn
}

output "lb_target_group_blue_name" {
  value = aws_lb_target_group.blue.name
}

output "lb_target_group_green_name" {
  value = aws_lb_target_group.green.name
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}
