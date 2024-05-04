# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway Attachment ID
# ----------------------------------------------------------------------------------------------
output "transit_gateway_attachment_id" {
  value = module.networking.transit_gateway_attachment_id
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway ID
# ----------------------------------------------------------------------------------------------
output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.this.id
}

# ----------------------------------------------------------------------------------------------
# RAM Resource Share Arn - Transit Gateway
# ----------------------------------------------------------------------------------------------
output "ram_resource_share_arn_tgw" {
  value = aws_ram_principal_association.tgw
}

# ----------------------------------------------------------------------------------------------
# RAM Resource Share Arn - Resolver Rules
# ----------------------------------------------------------------------------------------------
output "ram_resource_share_arn_resolver" {
  value = aws_ram_principal_association.resolver
}
