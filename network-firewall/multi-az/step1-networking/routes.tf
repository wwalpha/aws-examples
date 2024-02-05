# ----------------------------------------------------------------------------------------------
# AWS Route - APP VPC to Transit Gateway
# ----------------------------------------------------------------------------------------------
# resource "aws_route" "app_to_dmz" {
#   for_each               = toset(module.app_vpc.private_route_table_ids)
#   route_table_id         = each.value
#   destination_cidr_block = "0.0.0.0/0"
#   transit_gateway_id     = aws_ec2_transit_gateway.this.id

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# ----------------------------------------------------------------------------------------------
# AWS Route - APP DMZ Public to Transit Gateway
# ----------------------------------------------------------------------------------------------
# resource "aws_route" "dmz_nat_to_app" {
#   for_each               = toset(module.dmz_vpc.public_route_table_ids)
#   route_table_id         = each.value
#   destination_cidr_block = local.vpc_cidr_block_app
#   transit_gateway_id     = aws_ec2_transit_gateway.this.id
# }
