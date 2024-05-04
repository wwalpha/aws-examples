# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway Attachment ID
# ----------------------------------------------------------------------------------------------
output "transit_gateway_attachment_id" {
  value = module.networking.transit_gateway_attachment_id
}

# ----------------------------------------------------------------------------------------------
# Route53 Hosted Zone Name Servers
# ----------------------------------------------------------------------------------------------
output "hosted_zone_name_servers" {
  value = aws_route53_zone.this.name_servers
}
