# ----------------------------------------------------------------------------------------------
# Transit Gateway VPC Attachment
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  transit_gateway_id                              = var.transit_gateway_id
  vpc_id                                          = module.vpc.vpc_id
  subnet_ids                                      = module.vpc.private_subnets
  dns_support                                     = "enable"
  appliance_mode_support                          = "enable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags                                            = { Name = format("%s-tgw-attachment", var.prefix) }
}
