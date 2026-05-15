# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway - Demo
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway" "demo" {
  description                     = "Transit Gateway for the Network Firewall demo"
  amazon_side_asn                 = 64512
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"

  tags = {
    Name = "${var.name_prefix}-tgw"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway VPC Attachment - Workload
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "workload" {
  subnet_ids         = [aws_subnet.workload["tgw_attachment_a"].id]
  transit_gateway_id = aws_ec2_transit_gateway.demo.id
  vpc_id             = aws_vpc.workload.id
  dns_support        = "enable"
  ipv6_support       = "disable"

  tags = {
    Name = "${var.name_prefix}-workload-tgw-attachment"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway VPC Attachment - Egress
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "egress" {
  subnet_ids             = [aws_subnet.egress["tgw_attachment_a"].id]
  transit_gateway_id     = aws_ec2_transit_gateway.demo.id
  vpc_id                 = aws_vpc.egress.id
  appliance_mode_support = "enable"
  dns_support            = "enable"
  ipv6_support           = "disable"

  tags = {
    Name = "${var.name_prefix}-egress-tgw-attachment"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway Route Table - Workload
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "workload" {
  transit_gateway_id = aws_ec2_transit_gateway.demo.id

  tags = {
    Name = "${var.name_prefix}-tgw-workload-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway Route Table - Egress
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "egress" {
  transit_gateway_id = aws_ec2_transit_gateway.demo.id

  tags = {
    Name = "${var.name_prefix}-tgw-egress-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway Route Table Association - Workload
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "workload" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.workload.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload.id
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway Route Table Association - Egress
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "egress" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.egress.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.egress.id
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway Route Table Propagation - Workload To Egress
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_propagation" "workload_to_egress" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.workload.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.egress.id
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway Route Table Propagation - Egress To Workload
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_propagation" "egress_to_workload" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.egress.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload.id
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway Route - Workload Default To Egress
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "workload_default_to_egress" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.egress.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload.id

  depends_on = [
    aws_ec2_transit_gateway_route_table_association.workload,
    aws_ec2_transit_gateway_route_table_association.egress,
  ]
}
