# ----------------------------------------------------------------------------------------------
# Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway" "this" {
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  multicast_support               = "disable"
  vpn_ecmp_support                = "disable"
  dns_support                     = "enable"

  tags = {
    Name = "${var.prefix}-tgw"
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway VPC Attachment - Ingress
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "onpremise" {
  transit_gateway_id                              = aws_ec2_transit_gateway.this.id
  vpc_id                                          = aws_vpc.onpremise.id
  subnet_ids                                      = aws_subnet.onpremise[*].id
  dns_support                                     = "enable"
  appliance_mode_support                          = "enable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags                                            = { Name = format("%s-onpremise-tgw-attachment", var.prefix) }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway VPC Attachment - Egress
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "centraldns" {
  transit_gateway_id                              = aws_ec2_transit_gateway.this.id
  vpc_id                                          = aws_vpc.central_dns.id
  subnet_ids                                      = aws_subnet.central_dns_private[*].id
  dns_support                                     = "enable"
  appliance_mode_support                          = "enable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags                                            = { Name = format("%s-centraldns-tgw-attachment", var.prefix) }
}
