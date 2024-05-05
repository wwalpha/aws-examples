# ----------------------------------------------------------------------------------------------
# AWS Route - Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_route" "tgw" {
  depends_on             = [aws_ram_resource_share_accepter.tgw]
  for_each               = toset(module.networking.vpc_private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.vpc_cidr_block_cloud
  transit_gateway_id     = var.transit_gateway_id
}
