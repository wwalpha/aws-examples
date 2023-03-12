output "rds_proxy_endpoint" {
  value = module.database.aws_rds_proxy.endpoint
}

output "rds_endpoint" {
  value = module.database.aws_rds_instance.address
}

output "rds_instance_id" {
  value = module.database.aws_rds_instance.id
}

output "ec2_instance_id" {
  value = module.app.ec2_instance_id
}

output "load_balancer_dns_name" {
  value = module.app.alb_dns_name
}
