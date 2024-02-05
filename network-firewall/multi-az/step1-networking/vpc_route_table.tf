# ----------------------------------------------------------------------------------------------
# AWS Route Table - DMZ Public Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "dmz_public" {
  depends_on = [aws_internet_gateway.this, aws_networkfirewall_firewall.this]
  count      = length(local.cidr_block_dmz_subnets_public)

  vpc_id = aws_vpc.dmz.id

  # 0.0.0.0/0 > Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  # 10.0.0.0/8 > Firewall Endpoint
  route {
    cidr_block      = local.cidr_block_aws_cloud
    vpc_endpoint_id = local.firewall_endpoints[count.index]
  }

  tags = {
    Name = format(
      "${aws_vpc.dmz.tags.Name}-dmz-public-rt-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - DMZ Public Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "dmz_public" {
  count = length(local.cidr_block_dmz_subnets_public)

  subnet_id      = element(aws_subnet.dmz_public[*].id, count.index)
  route_table_id = element(aws_route_table.dmz_public[*].id, count.index)
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - DMZ Firewall Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "dmz_firewall" {
  depends_on = [aws_nat_gateway.this, module.dmz_vpc_attachment]
  count      = length(local.cidr_block_dmz_subnets_firewall)

  vpc_id = aws_vpc.dmz.id

  # 10.0.0.0/8 > Transit Gateway
  route {
    cidr_block         = local.cidr_block_aws_cloud
    transit_gateway_id = aws_ec2_transit_gateway.this.id
  }

  # 0.0.0.0/0 > NAT Gateway
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[count.index].id
  }

  tags = {
    Name = format(
      "${aws_vpc.dmz.tags.Name}-dmz-firewall-rt-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - DMZ Firewall Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "dmz_firewall" {
  count = length(local.cidr_block_dmz_subnets_firewall)

  subnet_id      = element(aws_subnet.dmz_firewall[*].id, count.index)
  route_table_id = element(aws_route_table.dmz_firewall[*].id, count.index)
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - DMZ Intra Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "dmz_intra" {
  depends_on = [aws_networkfirewall_firewall.this]
  count      = length(local.cidr_block_dmz_subnets_intra)

  vpc_id = aws_vpc.dmz.id

  # 0.0.0.0/0 > Firewall Endpoint
  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = local.firewall_endpoints[count.index]
  }

  tags = {
    Name = format(
      "${aws_vpc.dmz.tags.Name}-dmz-intra-rt-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - DMZ Intra Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "dmz_intra" {
  count = length(local.cidr_block_dmz_subnets_intra)

  subnet_id      = element(aws_subnet.dmz_intra[*].id, count.index)
  route_table_id = element(aws_route_table.dmz_intra[*].id, count.index)
}
