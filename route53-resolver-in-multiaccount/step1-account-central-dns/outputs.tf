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
# RAM Resource Share Arn - Transit Gateway
# ----------------------------------------------------------------------------------------------
output "ram_resource_share_arn_tgw" {
  value = aws_ram_principal_association.tgw
}

# ----------------------------------------------------------------------------------------------
# RAM Resource Share Arn - Resolver Rules Forward
# ----------------------------------------------------------------------------------------------
output "ram_resolver_rule_forward" {
  value = aws_ram_principal_association.resolver_rule_forward
}

# ----------------------------------------------------------------------------------------------
# RAM Resource Share Arn - Resolver Rules System
# ----------------------------------------------------------------------------------------------
output "ram_resolver_rule_system" {
  value = aws_ram_principal_association.resolver_rule_system
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
