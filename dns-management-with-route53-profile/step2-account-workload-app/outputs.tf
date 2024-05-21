# ----------------------------------------------------------------------------------------------
# AWS VPC ID
# ----------------------------------------------------------------------------------------------
output "vpc_id" {
  value = module.networking.vpc_id
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway Attachment ID
# ----------------------------------------------------------------------------------------------
output "transit_gateway_attachment_id" {
  value = module.networking.transit_gateway_attachment_id
}

# ----------------------------------------------------------------------------------------------
# VPC Private Route Table IDs
# ----------------------------------------------------------------------------------------------
output "vpc_private_route_table_ids" {
  value = module.networking.vpc_private_route_table_ids
}

# ----------------------------------------------------------------------------------------------
# ALB DNS Name
# ----------------------------------------------------------------------------------------------
output "alb_dns_name" {
  value = module.application.alb_dns_name
}

# ----------------------------------------------------------------------------------------------
# ALB Zone ID
# ----------------------------------------------------------------------------------------------
output "alb_zone_id" {
  value = module.application.alb_zone_id
}
