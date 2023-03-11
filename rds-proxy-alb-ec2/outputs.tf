output "private_subnets_cidr_block" {
  value = module.networking.private_subnets_cidr_blocks
}

output "aws_db_proxy_endpoint" {
  value = module.database.aws_rds_proxy.endpoint
}

output "aws_db_endpoint" {
  value = module.database.aws_rds_instance.address
}

output "aws_db_instance_id" {
  value = module.database.aws_rds_instance.id
}

output "alb_dns_name" {
  value = module.app.alb_dns_name
}
