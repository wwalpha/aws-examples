# ----------------------------------------------------------------------------------------------
# AWS Route Table - Workload Intra Private Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "workload_intra_private" {
  depends_on = [aws_ec2_transit_gateway.this]
  vpc_id     = aws_vpc.workload_intra.id

  # 0.0.0.0/0 > Transit Gateway
  route {
    cidr_block         = local.cidr_block_internet
    transit_gateway_id = aws_ec2_transit_gateway.this.id
  }

  tags = {
    Name = "${aws_vpc.workload_intra.tags.Name}-private-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Workload Intra Private Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "workload_intra_private" {
  count          = length(aws_subnet.workload_intra_private[*].id)
  subnet_id      = element(aws_subnet.workload_intra_private[*].id, count.index)
  route_table_id = aws_route_table.workload_intra_private.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Workload Web Public Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "workload_web_public" {
  depends_on = [aws_ec2_transit_gateway.this]
  vpc_id     = aws_vpc.workload_web.id

  # 0.0.0.0/0 > Internet Gateway
  route {
    cidr_block = local.cidr_block_internet
    gateway_id = aws_internet_gateway.workload_web.id
  }

  tags = {
    Name = "${aws_vpc.workload_web.tags.Name}-public-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Workload Web Private Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "workload_web_public" {
  count          = length(aws_subnet.workload_web_public[*].id)
  subnet_id      = element(aws_subnet.workload_web_public[*].id, count.index)
  route_table_id = aws_route_table.workload_web_public.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Workload Web Private Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "workload_web_private" {
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.workload_web]
  vpc_id     = aws_vpc.workload_web.id

  # 0.0.0.0/0 > Transit Gateway
  route {
    cidr_block         = local.cidr_block_internet
    transit_gateway_id = aws_ec2_transit_gateway.this.id
  }

  tags = {
    Name = "${aws_vpc.workload_web.tags.Name}-private-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Workload Web Private Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "workload_web_private" {
  count          = length(aws_subnet.workload_web_private[*].id)
  subnet_id      = element(aws_subnet.workload_web_private[*].id, count.index)
  route_table_id = aws_route_table.workload_web_private.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Egress Public Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "egress_public" {
  depends_on = [aws_ec2_transit_gateway.this]
  count      = length(aws_subnet.egress_public[*].id)
  vpc_id     = aws_vpc.egress.id

  # 0.0.0.0/0 > Internet Gateway
  route {
    cidr_block = local.cidr_block_internet
    gateway_id = aws_internet_gateway.egress.id
  }

  # 10.0.0.0/8 > Network Firewall
  route {
    cidr_block      = local.cidr_block_awscloud
    vpc_endpoint_id = element([for ss in local.firewall_endpoints_egress : ss.attachment[0].endpoint_id if ss.availability_zone == aws_subnet.egress_public[count.index].availability_zone], 0)
  }

  tags = {
    Name = format(
      "${aws_vpc.egress.tags.Name}-public-rt-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Egress Public Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "egress_public" {
  count          = length(aws_subnet.egress_public[*].id)
  subnet_id      = element(aws_subnet.egress_public[*].id, count.index)
  route_table_id = element(aws_route_table.egress_public[*].id, count.index)
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Egress Firewall Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "egress_firewall" {
  depends_on = [aws_ec2_transit_gateway.this]
  count      = length(aws_subnet.egress_firewall[*].id)
  vpc_id     = aws_vpc.egress.id

  # 0.0.0.0/0 > NAT Gateway
  route {
    cidr_block     = local.cidr_block_internet
    nat_gateway_id = element(aws_nat_gateway.egress_nat[*].id, count.index)
  }

  # 10.0.0.0/8 > Transit Gateway
  route {
    cidr_block         = local.cidr_block_awscloud
    transit_gateway_id = aws_ec2_transit_gateway.this.id
  }

  tags = {
    Name = format(
      "${aws_vpc.egress.tags.Name}-firewall-rt-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Egress Firewall Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "egress_firewall" {
  count          = length(aws_subnet.egress_firewall[*].id)
  subnet_id      = element(aws_subnet.egress_firewall[*].id, count.index)
  route_table_id = element(aws_route_table.egress_firewall[*].id, count.index)
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Egress TGW Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "egress_tgw" {
  depends_on = [aws_ec2_transit_gateway.this]
  count      = length(aws_subnet.egress_tgw[*].id)
  vpc_id     = aws_vpc.egress.id

  # 0.0.0.0/0 > Network Firewall
  route {
    cidr_block      = local.cidr_block_internet
    vpc_endpoint_id = element([for ss in local.firewall_endpoints_egress : ss.attachment[0].endpoint_id if ss.availability_zone == aws_subnet.egress_tgw[count.index].availability_zone], 0)
  }

  # 10.0.0.0/8 > Transit Gateway
  route {
    cidr_block         = local.cidr_block_awscloud
    transit_gateway_id = aws_ec2_transit_gateway.this.id
  }

  tags = {
    Name = format(
      "${aws_vpc.egress.tags.Name}-tgw-rt-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Egress TGW Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "egress_tgw" {
  count          = length(aws_subnet.egress_tgw[*].id)
  subnet_id      = element(aws_subnet.egress_tgw[*].id, count.index)
  route_table_id = element(aws_route_table.egress_tgw[*].id, count.index)
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Ingress Public Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "ingress_public" {
  depends_on = [aws_ec2_transit_gateway.this]
  vpc_id     = aws_vpc.ingress.id

  # 0.0.0.0/0 > Internet Gateway
  route {
    cidr_block = local.cidr_block_internet
    gateway_id = aws_internet_gateway.ingress.id
  }

  # 10.0.0.0/8 > Transit Gateway
  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.this.id
  }

  tags = {
    Name = "${aws_vpc.ingress.tags.Name}-public-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Ingress Public Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "ingress_public" {
  count          = length(aws_subnet.ingress_public[*].id)
  subnet_id      = element(aws_subnet.ingress_public[*].id, count.index)
  route_table_id = aws_route_table.ingress_public.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Ingress TGW Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "ingress_tgw" {
  depends_on = [aws_ec2_transit_gateway.this]
  vpc_id     = aws_vpc.ingress.id

  # 10.0.0.0/8 > Transit Gateway
  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.this.id
  }

  tags = {
    Name = "${aws_vpc.ingress.tags.Name}-tgw-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Ingress TGW Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "ingress_tgw" {
  count          = length(aws_subnet.ingress_tgw[*].id)
  subnet_id      = element(aws_subnet.ingress_tgw[*].id, count.index)
  route_table_id = aws_route_table.ingress_tgw.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Inspection Firewall Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "inspection_firewall" {
  depends_on = [aws_ec2_transit_gateway.this]
  vpc_id     = aws_vpc.inspection.id

  # 0.0.0.0/0 > Transit Gateway
  route {
    cidr_block         = local.cidr_block_internet
    transit_gateway_id = aws_ec2_transit_gateway.this.id
  }

  tags = {
    Name = "${aws_vpc.inspection.tags.Name}-firewall-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Inspection Firewall Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "inspection_firewall" {
  count          = length(aws_subnet.inspection_firewall[*].id)
  subnet_id      = element(aws_subnet.inspection_firewall[*].id, count.index)
  route_table_id = aws_route_table.inspection_firewall.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Inspection TGW Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "inspection_tgw" {
  depends_on = [aws_ec2_transit_gateway.this]
  count      = length(aws_subnet.inspection_tgw[*].id)
  vpc_id     = aws_vpc.inspection.id

  # 0.0.0.0/0 > Transit Gateway
  route {
    cidr_block      = local.cidr_block_internet
    vpc_endpoint_id = element([for ss in local.firewall_endpoints_inspection : ss.attachment[0].endpoint_id if ss.availability_zone == aws_subnet.inspection_tgw[count.index].availability_zone], 0)
  }

  tags = {
    Name = format(
      "${aws_vpc.inspection.tags.Name}-tgw-rt-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Inspection TGW Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "inspection_tgw" {
  count          = length(aws_subnet.inspection_tgw[*].id)
  subnet_id      = element(aws_subnet.inspection_tgw[*].id, count.index)
  route_table_id = element(aws_route_table.inspection_tgw[*].id, count.index)
}
