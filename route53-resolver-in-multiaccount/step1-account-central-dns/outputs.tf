# ----------------------------------------------------------------------------------------------
# AWS VPC ID
# ----------------------------------------------------------------------------------------------
output "vpc_id" {
  value = module.networking.vpc_id
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway ID
# ----------------------------------------------------------------------------------------------
output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.this.id
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway Attachment ID
# ----------------------------------------------------------------------------------------------
output "transit_gateway_attachment_id" {
  value = module.networking.transit_gateway_attachment_id
}

# ----------------------------------------------------------------------------------------------
# Route53 Hosted Zone ID
# ----------------------------------------------------------------------------------------------
output "hosted_zone_id" {
  value = aws_route53_zone.this.id
}

# ----------------------------------------------------------------------------------------------
# Route53 Resolver Inbound Endpoints
# ----------------------------------------------------------------------------------------------
output "route53_resolver_inbound_endpoints" {
  value = aws_route53_resolver_endpoint.inbound.ip_address
}

# ----------------------------------------------------------------------------------------------
# Route53 Resolver Outbound Endpoints
# ----------------------------------------------------------------------------------------------
output "route53_resolver_outbound_endpoints" {
  value = aws_route53_resolver_endpoint.outbound.ip_address
}

# # ----------------------------------------------------------------------------------------------
# # Route53 Resolver Rule ID - Forward Onpremise(master.local)
# # ----------------------------------------------------------------------------------------------
# output "resolver_rule_id_forward_onpremise" {
#   value = aws_route53_resolver_rule.forward_master_local.id
# }

# # ----------------------------------------------------------------------------------------------
# # Route53 Resolver Rule ID - Forward Cloud(master.aws)
# # ----------------------------------------------------------------------------------------------
# output "resolver_rule_id_forward_cloud" {
#   value = aws_route53_resolver_rule.forward_master_aws.id
# }

# # ----------------------------------------------------------------------------------------------
# # Route53 Resolver Rule ID - Forward SSM VPC Endpoint
# # ----------------------------------------------------------------------------------------------
# output "resolver_rule_id_forward_ssm_endpoint" {
#   value = aws_route53_resolver_rule.forward_ssm_endpoint.id
# }

# # ----------------------------------------------------------------------------------------------
# # Route53 Resolver Rule ID - System
# # ----------------------------------------------------------------------------------------------
# output "resolver_rule_id_system" {
#   value = aws_route53_resolver_rule.system.id
# }

# ----------------------------------------------------------------------------------------------
# VPC Private Route Table IDs
# ----------------------------------------------------------------------------------------------
output "vpc_private_route_table_ids" {
  value = module.networking.vpc_private_route_table_ids
}
