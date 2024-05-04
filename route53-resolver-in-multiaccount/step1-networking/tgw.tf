# ----------------------------------------------------------------------------------------------
# Transit Gateway VPC Attachment
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  transit_gateway_id                              = var.transit_gateway_id
  vpc_id                                          = aws_vpc.this.id
  subnet_ids                                      = aws_subnet.private[*].id
  dns_support                                     = "enable"
  appliance_mode_support                          = "enable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags                                            = { Name = format("%s-tgw-attachment", var.prefix) }
}
