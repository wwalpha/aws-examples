# # ----------------------------------------------------------------------------------------------
# # AWS Route - Transit Gateway
# # ----------------------------------------------------------------------------------------------
# resource "aws_route" "private" {
#   count                  = length(module.vpc.private_route_table_ids)
#   route_table_id         = module.vpc.private_route_table_ids[count.index]
#   destination_cidr_block = local.vpc_cidr_block_cloud
#   transit_gateway_id     = var.transit_gateway_id
# }
