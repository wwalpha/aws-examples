resource "aws_route_table" "private" {
  depends_on = [aws_networkfirewall_firewall.this]
  count      = length(local.availability_zones)
  vpc_id     = aws_vpc.this.id

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = local.firewall_endpoints[count.index]
  }

  tags = {
    Name = format(
      "nfw_private_rt_%s",
      split("-", element(local.availability_zones, count.index))[2],
    )
  }
}

resource "aws_route_table_association" "private" {
  count          = length(local.availability_zones)
  route_table_id = aws_route_table.private[count.index].id
  subnet_id      = aws_subnet.private[count.index].id
}

resource "aws_route_table" "firewall" {
  count = length(local.availability_zones)

  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "nfw_firewall_rt"
  }
}

resource "aws_route_table_association" "firewall" {
  count = length(local.availability_zones)

  route_table_id = aws_route_table.firewall[count.index].id
  subnet_id      = aws_subnet.firewall[count.index].id
}
