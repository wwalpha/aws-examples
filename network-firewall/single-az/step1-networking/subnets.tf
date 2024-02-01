resource "aws_subnet" "firewall" {
  count             = length(local.availability_zones)
  vpc_id            = aws_vpc.this.id
  cidr_block        = local.firewall_subnets_cidr_block[count.index]
  availability_zone = local.availability_zones[count.index]

  tags = {
    Name = format(
      "anfw-firewall-%s",
      element(local.availability_zones, count.index),
    )
  }
}

resource "aws_subnet" "private" {
  count             = length(local.availability_zones)
  vpc_id            = aws_vpc.this.id
  cidr_block        = local.private_subnets_cidr_block[count.index]
  availability_zone = local.availability_zones[count.index]

  tags = {
    Name = format(
      "anfw-private-%s",
      element(local.availability_zones, count.index),
    )
  }
}
