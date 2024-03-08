# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table - Workload
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "workload" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name = format("%s-workload-tgw-rt", var.prefix)
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Prefix List - Workload to Egress
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_prefix_list_reference" "workload_to_egress" {
  prefix_list_id                 = aws_ec2_managed_prefix_list.internet.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.egress.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload.id
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Prefix List - Workload to Ingress
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_prefix_list_reference" "workload_to_ingress" {
  prefix_list_id                 = aws_ec2_managed_prefix_list.ingress.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.ingress.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload.id
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table Association - Workload to Egress
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "workload_to_egress" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.workload.id
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table - Egress
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "egress" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name = format("%s-egress-tgw-rt", var.prefix)
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route - Egress to Workload
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "egress_to_workload" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.egress.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.workload.id
  destination_cidr_block         = local.vpc_cidr_block_workload
  blackhole                      = false
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table Association
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "egress_to_workload" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.egress.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.egress.id
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table - Ingress
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "ingress" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name = format("%s-ingress-tgw-rt", var.prefix)
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route - Egress to Workload
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "ingress_to_workload" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ingress.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.workload.id
  destination_cidr_block         = local.vpc_cidr_block_workload
  blackhole                      = false
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table Association
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "ingress_to_workload" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ingress.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.ingress.id
}
