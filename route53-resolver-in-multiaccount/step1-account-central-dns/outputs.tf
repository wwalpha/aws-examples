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
# RAM Invitation Arn - Transit Gateway
# ----------------------------------------------------------------------------------------------
output "ram_share_arn_transit_gateway" {
  value = aws_ram_principal_association.tgw
}

# ----------------------------------------------------------------------------------------------
# RAM Invitation Arn - Resolver Rules Forward Onpremise(master.local)
# ----------------------------------------------------------------------------------------------
output "ram_share_arn_resolver_forward_onpremise" {
  value = aws_ram_principal_association.resolver_forward_onpremise
}

# ----------------------------------------------------------------------------------------------
# RAM Invitation Arn - Resolver Rules Forward Cloud(master.aws)
# ----------------------------------------------------------------------------------------------
output "ram_share_arn_resolver_forward_cloud" {
  value = aws_ram_principal_association.resolver_forward_cloud
}

# ----------------------------------------------------------------------------------------------
# RAM Invitation Arn - Resolver Rules System
# ----------------------------------------------------------------------------------------------
output "ram_share_arn_resolver_system" {
  value = aws_ram_principal_association.resolver_system
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

# ----------------------------------------------------------------------------------------------
# Route53 Resolver Rule ID - Forward Onpremise(master.local)
# ----------------------------------------------------------------------------------------------
output "resolver_rule_id_forward_onpremise" {
  value = aws_route53_resolver_rule.forward_master_local.id
}

# ----------------------------------------------------------------------------------------------
# Route53 Resolver Rule ID - Forward Cloud(master.aws)
# ----------------------------------------------------------------------------------------------
output "resolver_rule_id_forward_cloud" {
  value = aws_route53_resolver_rule.forward_master_aws.id
}

# ----------------------------------------------------------------------------------------------
# Route53 Resolver Rule ID - System
# ----------------------------------------------------------------------------------------------
output "resolver_rule_id_system" {
  value = aws_route53_resolver_rule.system.id
}

# ----------------------------------------------------------------------------------------------
# VPC Private Route Table IDs
# ----------------------------------------------------------------------------------------------
output "vpc_private_route_table_ids" {
  value = module.networking.vpc_private_route_table_ids
}
