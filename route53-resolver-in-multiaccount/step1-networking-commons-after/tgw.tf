# # ----------------------------------------------------------------------------------------------
# # Transit Gateway
# # ----------------------------------------------------------------------------------------------
# resource "aws_ec2_transit_gateway" "this" {
#   default_route_table_association = "disable"
#   default_route_table_propagation = "disable"
#   multicast_support               = "disable"
#   vpn_ecmp_support                = "disable"
#   dns_support                     = "enable"

#   tags = {
#     Name = "${var.prefix}-tgw"
#   }
# }

# # ----------------------------------------------------------------------------------------------
# # Transit Gateway VPC Attachment - Central DNS
# # ----------------------------------------------------------------------------------------------
# resource "aws_ec2_transit_gateway_vpc_attachment" "central_dns" {
#   transit_gateway_id                              = aws_ec2_transit_gateway.this.id
#   vpc_id                                          = aws_vpc.this.id
#   subnet_ids                                      = aws_subnet.this[*].id
#   dns_support                                     = "enable"
#   appliance_mode_support                          = "enable"
#   transit_gateway_default_route_table_association = false
#   transit_gateway_default_route_table_propagation = false
#   tags                                            = { Name = format("%s-central-dns-tgw-attachment", var.prefix) }
# }
