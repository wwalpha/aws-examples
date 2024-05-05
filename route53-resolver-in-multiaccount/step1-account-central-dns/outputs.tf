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
output "ram_invitation_arn_transit_gateway" {
  value = aws_ram_principal_association.tgw
}

# ----------------------------------------------------------------------------------------------
# RAM Invitation Arn - Resolver Rules Forward master.local
# ----------------------------------------------------------------------------------------------
output "ram_invitation_arn_resolver_rule_forward_master_local" {
  value = aws_ram_principal_association.resolver_rule_forward_master_local
}

# ----------------------------------------------------------------------------------------------
# RAM Invitation Arn - Resolver Rules Forward master.aws
# ----------------------------------------------------------------------------------------------
output "ram_invitation_arn_resolver_rule_forward_master_aws" {
  value = aws_ram_principal_association.resolver_rule_forward_master_aws
}

# ----------------------------------------------------------------------------------------------
# RAM Invitation Arn - Resolver Rules System
# ----------------------------------------------------------------------------------------------
output "ram_invitation_arn_resolver_rule_system" {
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

# ----------------------------------------------------------------------------------------------
# Route53 Resolver Rule ID - Forward master.local
# ----------------------------------------------------------------------------------------------
output "route53_resolver_rule_id_forward_master_local" {
  value = aws_route53_resolver_rule.forward_master_local.id
}

# ----------------------------------------------------------------------------------------------
# Route53 Resolver Rule ID - Forward master.aws
# ----------------------------------------------------------------------------------------------
output "route53_resolver_rule_id_forward_master_aws" {
  value = aws_route53_resolver_rule.forward_master_aws.id
}

# ----------------------------------------------------------------------------------------------
# Route53 Resolver Rule ID - System
# ----------------------------------------------------------------------------------------------
output "route53_resolver_rule_system_id" {
  value = aws_route53_resolver_rule.system.id
}
