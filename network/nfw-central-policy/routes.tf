# ----------------------------------------------------------------------------------------------
# Time Sleep - NAT Gateway Ready
# ----------------------------------------------------------------------------------------------
resource "time_sleep" "nat_gateway_ready" {
  create_duration = var.nat_gateway_wait_duration

  depends_on = [aws_nat_gateway.egress]
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Workload IGW Ingress
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "workload_igw_ingress" {
  vpc_id = aws_vpc.workload.id

  tags = {
    Name = "${var.name_prefix}-workload-igw-ingress-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Workload IGW Ingress
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "workload_igw_ingress" {
  gateway_id     = aws_internet_gateway.workload.id
  route_table_id = aws_route_table.workload_igw_ingress.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route - Workload IGW Ingress ALB A
# ----------------------------------------------------------------------------------------------
resource "aws_route" "workload_igw_ingress_alb_a" {
  route_table_id         = aws_route_table.workload_igw_ingress.id
  destination_cidr_block = local.workload_subnets["alb_public_a"].cidr
  vpc_endpoint_id        = local.workload_firewall_endpoint_ids[local.workload_az_a]
}

# ----------------------------------------------------------------------------------------------
# AWS Route - Workload IGW Ingress ALB C
# ----------------------------------------------------------------------------------------------
resource "aws_route" "workload_igw_ingress_alb_c" {
  route_table_id         = aws_route_table.workload_igw_ingress.id
  destination_cidr_block = local.workload_subnets["alb_public_c"].cidr
  vpc_endpoint_id        = local.workload_firewall_endpoint_ids[local.workload_az_c]
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Workload ALB Public A
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "workload_alb_public_a" {
  vpc_id = aws_vpc.workload.id

  tags = {
    Name = "${var.name_prefix}-workload-alb-public-a-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route - Workload ALB Public A Default
# ----------------------------------------------------------------------------------------------
resource "aws_route" "workload_alb_public_a_default" {
  route_table_id         = aws_route_table.workload_alb_public_a.id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = local.workload_firewall_endpoint_ids[local.workload_az_a]
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Workload ALB Public A
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "workload_alb_public_a" {
  subnet_id      = aws_subnet.workload["alb_public_a"].id
  route_table_id = aws_route_table.workload_alb_public_a.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Workload ALB Public C
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "workload_alb_public_c" {
  vpc_id = aws_vpc.workload.id

  tags = {
    Name = "${var.name_prefix}-workload-alb-public-c-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route - Workload ALB Public C Default
# ----------------------------------------------------------------------------------------------
resource "aws_route" "workload_alb_public_c_default" {
  route_table_id         = aws_route_table.workload_alb_public_c.id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = local.workload_firewall_endpoint_ids[local.workload_az_c]
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Workload ALB Public C
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "workload_alb_public_c" {
  subnet_id      = aws_subnet.workload["alb_public_c"].id
  route_table_id = aws_route_table.workload_alb_public_c.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Workload NFW A
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "workload_nfw_a" {
  vpc_id = aws_vpc.workload.id

  tags = {
    Name = "${var.name_prefix}-workload-nfw-a-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route - Workload NFW A Default
# ----------------------------------------------------------------------------------------------
resource "aws_route" "workload_nfw_a_default" {
  route_table_id         = aws_route_table.workload_nfw_a.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.workload.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Workload NFW A
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "workload_nfw_a" {
  subnet_id      = aws_subnet.workload["nfw_endpoint_a"].id
  route_table_id = aws_route_table.workload_nfw_a.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Workload NFW C
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "workload_nfw_c" {
  vpc_id = aws_vpc.workload.id

  tags = {
    Name = "${var.name_prefix}-workload-nfw-c-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route - Workload NFW C Default
# ----------------------------------------------------------------------------------------------
resource "aws_route" "workload_nfw_c_default" {
  route_table_id         = aws_route_table.workload_nfw_c.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.workload.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Workload NFW C
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "workload_nfw_c" {
  subnet_id      = aws_subnet.workload["nfw_endpoint_c"].id
  route_table_id = aws_route_table.workload_nfw_c.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Workload Private
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "workload_private" {
  vpc_id = aws_vpc.workload.id

  tags = {
    Name = "${var.name_prefix}-workload-private-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route - Workload Private Default To TGW
# ----------------------------------------------------------------------------------------------
resource "aws_route" "workload_private_default_to_tgw" {
  route_table_id         = aws_route_table.workload_private.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.demo.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Workload Private
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "workload_private" {
  subnet_id      = aws_subnet.workload["ec2_private_a"].id
  route_table_id = aws_route_table.workload_private.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Workload TGW Attachment
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "workload_tgw_attachment" {
  vpc_id = aws_vpc.workload.id

  tags = {
    Name = "${var.name_prefix}-workload-tgw-attachment-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Workload TGW Attachment
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "workload_tgw_attachment" {
  subnet_id      = aws_subnet.workload["tgw_attachment_a"].id
  route_table_id = aws_route_table.workload_tgw_attachment.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Egress TGW Attachment
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "egress_tgw_attachment" {
  vpc_id = aws_vpc.egress.id

  tags = {
    Name = "${var.name_prefix}-egress-tgw-attachment-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route - Egress TGW Default To NFW
# ----------------------------------------------------------------------------------------------
resource "aws_route" "egress_tgw_default_to_nfw" {
  route_table_id         = aws_route_table.egress_tgw_attachment.id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = local.egress_firewall_endpoint_ids[local.egress_az_a]

  depends_on = [time_sleep.nat_gateway_ready]
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Egress TGW Attachment
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "egress_tgw_attachment" {
  subnet_id      = aws_subnet.egress["tgw_attachment_a"].id
  route_table_id = aws_route_table.egress_tgw_attachment.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Egress NFW
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "egress_nfw" {
  vpc_id = aws_vpc.egress.id

  tags = {
    Name = "${var.name_prefix}-egress-nfw-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route - Egress NFW Default To NAT
# ----------------------------------------------------------------------------------------------
resource "aws_route" "egress_nfw_default_to_nat" {
  route_table_id         = aws_route_table.egress_nfw.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.egress.id

  depends_on = [time_sleep.nat_gateway_ready]
}

# ----------------------------------------------------------------------------------------------
# AWS Route - Egress NFW To Workload
# ----------------------------------------------------------------------------------------------
resource "aws_route" "egress_nfw_to_workload" {
  route_table_id         = aws_route_table.egress_nfw.id
  destination_cidr_block = local.workload_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.demo.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Egress NFW
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "egress_nfw" {
  subnet_id      = aws_subnet.egress["nfw_endpoint_a"].id
  route_table_id = aws_route_table.egress_nfw.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Egress NAT Public
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "egress_nat_public" {
  vpc_id = aws_vpc.egress.id

  tags = {
    Name = "${var.name_prefix}-egress-nat-public-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route - Egress NAT Default To IGW
# ----------------------------------------------------------------------------------------------
resource "aws_route" "egress_nat_default_to_igw" {
  route_table_id         = aws_route_table.egress_nat_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.egress.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route - Egress NAT To Workload Via NFW
# ----------------------------------------------------------------------------------------------
resource "aws_route" "egress_nat_to_workload_via_nfw" {
  route_table_id         = aws_route_table.egress_nat_public.id
  destination_cidr_block = local.workload_vpc_cidr
  vpc_endpoint_id        = local.egress_firewall_endpoint_ids[local.egress_az_a]

  depends_on = [time_sleep.nat_gateway_ready]
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Egress NAT Public
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "egress_nat_public" {
  subnet_id      = aws_subnet.egress["nat_public_a"].id
  route_table_id = aws_route_table.egress_nat_public.id
}

# ----------------------------------------------------------------------------------------------
# Time Sleep - Egress Path Ready
# ----------------------------------------------------------------------------------------------
resource "time_sleep" "egress_path_ready" {
  create_duration = var.egress_path_wait_duration

  depends_on = [
    time_sleep.nat_gateway_ready,
    aws_ec2_transit_gateway_route.workload_default_to_egress,
    aws_ec2_transit_gateway_route_table_propagation.workload_to_egress,
    aws_ec2_transit_gateway_route_table_propagation.egress_to_workload,
    aws_route.workload_private_default_to_tgw,
    aws_route.egress_tgw_default_to_nfw,
    aws_route.egress_nfw_default_to_nat,
    aws_route.egress_nfw_to_workload,
    aws_route.egress_nat_to_workload_via_nfw,
  ]
}
