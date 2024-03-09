# ----------------------------------------------------------------------------------------------
# Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway" "this" {
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  multicast_support               = "disable"
  vpn_ecmp_support                = "disable"
  dns_support                     = "enable"
  transit_gateway_cidr_blocks     = [local.cidr_block_tgw]

  tags = {
    Name = "${var.prefix}-tgw"
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway VPC Attachment - Ingress
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "ingress" {
  transit_gateway_id                              = aws_ec2_transit_gateway.this.id
  vpc_id                                          = aws_vpc.ingress.id
  subnet_ids                                      = aws_subnet.ingress_tgw[*].id
  dns_support                                     = "enable"
  appliance_mode_support                          = "enable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags                                            = { Name = format("%s-ingress-tgw-attachment", var.prefix) }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway VPC Attachment - Egress
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "egress" {
  transit_gateway_id                              = aws_ec2_transit_gateway.this.id
  vpc_id                                          = aws_vpc.egress.id
  subnet_ids                                      = aws_subnet.egress_tgw[*].id
  dns_support                                     = "enable"
  appliance_mode_support                          = "enable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags                                            = { Name = format("%s-egress-tgw-attachment", var.prefix) }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway VPC Attachment - Workload Intra
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "workload_intra" {
  transit_gateway_id                              = aws_ec2_transit_gateway.this.id
  vpc_id                                          = aws_vpc.workload_intra.id
  subnet_ids                                      = aws_subnet.workload_intra_tgw[*].id
  dns_support                                     = "enable"
  appliance_mode_support                          = "enable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags                                            = { Name = format("%s-workload-intra-tgw-attachment", var.prefix) }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway VPC Attachment - Workload Web
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "workload_web" {
  transit_gateway_id                              = aws_ec2_transit_gateway.this.id
  vpc_id                                          = aws_vpc.workload_web.id
  subnet_ids                                      = aws_subnet.workload_web_tgw[*].id
  dns_support                                     = "enable"
  appliance_mode_support                          = "enable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags                                            = { Name = format("%s-workload-web-tgw-attachment", var.prefix) }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway VPC Attachment - Inspection
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "inspection" {
  transit_gateway_id                              = aws_ec2_transit_gateway.this.id
  vpc_id                                          = aws_vpc.inspection.id
  subnet_ids                                      = aws_subnet.inspection_tgw[*].id
  dns_support                                     = "enable"
  appliance_mode_support                          = "enable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags                                            = { Name = format("%s-inspection-tgw-attachment", var.prefix) }
}
