# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table - Workload Intra
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "workload_intra" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name = format("%s-workload-intra-tgw-rt", var.prefix)
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route - Workload Intra to Workload Web
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "workload_intra_to_workload_web" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload_intra.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.inspection.id
  destination_cidr_block         = local.cidr_block_awscloud
  blackhole                      = false
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route - Workload to DataCenter
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "workload_intra_to_datacenter" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload_intra.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.inspection.id
  destination_cidr_block         = local.cidr_block_datacenter
  blackhole                      = false
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route - Workload Intra to Internet
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "workload_intra_to_internet" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload_intra.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.egress.id
  destination_cidr_block         = local.cidr_block_internet
  blackhole                      = false
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Prefix List - Workload Intra to Ingress
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_prefix_list_reference" "workload_intra_to_ingress" {
  prefix_list_id                 = aws_ec2_managed_prefix_list.ingress.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.ingress.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload_intra.id
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table Association - Workload Intra
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "workload_intra" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload_intra.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.workload_intra.id
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table - Workload Web
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "workload_web" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name = format("%s-workload-web-tgw-rt", var.prefix)
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route - Workload Web to Internet
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "workload_web_to_internet" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload_web.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.egress.id
  destination_cidr_block         = local.cidr_block_internet
  blackhole                      = false
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table Association - Workload Web
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "workload_web" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload_web.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.workload_web.id
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
# Transit Gateway Route - Egress to Workload Intra
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "egress_to_workload_intra" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.egress.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.workload_intra.id
  destination_cidr_block         = local.vpc_cidr_block_workload_intra
  blackhole                      = false
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route - Egress to Workload web
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "egress_to_workload_web" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.egress.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.workload_web.id
  destination_cidr_block         = local.vpc_cidr_block_workload_web
  blackhole                      = false
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table Association - Egress
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "egress" {
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
# Transit Gateway Route - Ingress to Workload Intra
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "ingress_to_workload_intra" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ingress.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.workload_intra.id
  destination_cidr_block         = local.vpc_cidr_block_workload_intra
  blackhole                      = false
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table Association - Ingress
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "ingress" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ingress.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.ingress.id
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table - Inspection
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "inspection" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name = format("%s-inspection-tgw-rt", var.prefix)
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route - Inspection to Workload Intra
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "inspection_to_workload_intra" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.inspection.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.workload_intra.id
  destination_cidr_block         = local.vpc_cidr_block_workload_intra
  blackhole                      = false
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route - Inspection to Workload Web
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "inspection_to_workload_web" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.inspection.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.workload_web.id
  destination_cidr_block         = local.vpc_cidr_block_workload_web
  blackhole                      = false
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route - Inspection to Internet
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "inspection_to_internet" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.inspection.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.egress.id
  destination_cidr_block         = local.cidr_block_internet
  blackhole                      = false
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table Association - Inspection
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "inspection" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.inspection.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.inspection.id
}
