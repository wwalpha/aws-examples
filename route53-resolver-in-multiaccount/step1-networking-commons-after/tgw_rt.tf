# # ----------------------------------------------------------------------------------------------
# # Transit Gateway Route Table - Central DNS
# # ----------------------------------------------------------------------------------------------
# resource "aws_ec2_transit_gateway_route_table" "this" {
#   transit_gateway_id = aws_ec2_transit_gateway.this.id

#   tags = {
#     Name = format("%s-central-dns-tgw-rt", var.prefix)
#   }
# }

# # ----------------------------------------------------------------------------------------------
# # Transit Gateway Route - Onpremise to CentralDNS
# # ----------------------------------------------------------------------------------------------
# resource "aws_ec2_transit_gateway_route" "onpremise_to_centraldns" {
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.onpremise.id
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.centraldns.id
#   destination_cidr_block         = local.vpc_cidr_block_central_dns
#   blackhole                      = false
# }

# # ----------------------------------------------------------------------------------------------
# # Transit Gateway Route Table Association - Onpremise
# # ----------------------------------------------------------------------------------------------
# resource "aws_ec2_transit_gateway_route_table_association" "onpremise" {
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.onpremise.id
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.onpremise.id
# }

# # ----------------------------------------------------------------------------------------------
# # Transit Gateway Route Table - Central DNS
# # ----------------------------------------------------------------------------------------------
# resource "aws_ec2_transit_gateway_route_table" "centraldns" {
#   transit_gateway_id = aws_ec2_transit_gateway.this.id

#   tags = {
#     Name = format("%s-centraldns-tgw-rt", var.prefix)
#   }
# }

# # ----------------------------------------------------------------------------------------------
# # Transit Gateway Route - CentralDNS to Onpremise
# # ----------------------------------------------------------------------------------------------
# resource "aws_ec2_transit_gateway_route" "centraldns_to_onpremise" {
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.centraldns.id
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.onpremise.id
#   destination_cidr_block         = local.vpc_cidr_block_onpremise
#   blackhole                      = false
# }

# # ----------------------------------------------------------------------------------------------
# # Transit Gateway Route Table Association - CentralDNS
# # ----------------------------------------------------------------------------------------------
# resource "aws_ec2_transit_gateway_route_table_association" "centraldns" {
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.centraldns.id
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.centraldns.id
# }
