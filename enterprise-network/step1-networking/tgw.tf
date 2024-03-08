# ----------------------------------------------------------------------------------------------
# Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway" "this" {
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  multicast_support               = "disable"
  vpn_ecmp_support                = "disable"
  dns_support                     = "enable"
  transit_gateway_cidr_blocks     = [local.tgw_cidr_block]

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
# Transit Gateway VPC Attachment - Workload
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "workload" {
  transit_gateway_id                              = aws_ec2_transit_gateway.this.id
  vpc_id                                          = aws_vpc.workload.id
  subnet_ids                                      = aws_subnet.workload_tgw[*].id
  dns_support                                     = "enable"
  appliance_mode_support                          = "enable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags                                            = { Name = format("%s-workload-tgw-attachment", var.prefix) }
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

# # ----------------------------------------------------------------------------------------------
# # Transit Gateway Route Table - App VPC
# # ----------------------------------------------------------------------------------------------
# resource "aws_ec2_transit_gateway_route_table" "vpc_app" {
#   transit_gateway_id = aws_ec2_transit_gateway.this.id
#   tags = {
#     Name = "${var.prefix}-app-tgw-rt"
#   }
# }

# # ----------------------------------------------------------------------------------------------
# # Transit Gateway Route
# # ----------------------------------------------------------------------------------------------
# resource "aws_ec2_transit_gateway_route" "app_to_dmz" {
#   destination_cidr_block         = "0.0.0.0/0"
#   blackhole                      = false
#   transit_gateway_attachment_id  = module.dmz_vpc_attachment.transit_gateway_vpc_attachment_id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc_app.id
# }

# # ----------------------------------------------------------------------------------------------
# # Transit Gateway Route Table Association
# # ----------------------------------------------------------------------------------------------
# resource "aws_ec2_transit_gateway_route_table_association" "vpc_app" {
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_app.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc_app.id
# }

# # ----------------------------------------------------------------------------------------------
# # Transit Gateway Route Table Propagation
# # ----------------------------------------------------------------------------------------------
# resource "aws_ec2_transit_gateway_route_table_propagation" "vpc_app" {
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_app.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc_app.id
# }
