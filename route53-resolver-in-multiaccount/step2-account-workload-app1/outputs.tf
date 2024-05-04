# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway Attachment ID
# ----------------------------------------------------------------------------------------------
output "transit_gateway_attachment_id" {
  value = module.networking.transit_gateway_attachment_id
}
