# ----------------------------------------------------------------------------------------------
# AWS Subnet - Firewall
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "firewall" {
  count             = length(local.availability_zones)
  vpc_id            = aws_vpc.this.id
  cidr_block        = local.firewall_subnets_cidr_block[count.index]
  availability_zone = local.availability_zones[count.index]

  tags = {
    Name = format(
      "nfw-firewall-%s",
      element(local.availability_zones, count.index),
    )
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Subnet - Public
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "public" {
  count             = length(local.availability_zones)
  vpc_id            = aws_vpc.this.id
  cidr_block        = local.public_subnets_cidr_block[count.index]
  availability_zone = local.availability_zones[count.index]

  tags = {
    Name = format(
      "nfw-public-%s",
      element(local.availability_zones, count.index),
    )
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Subnet - Private
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "private" {
  count             = length(local.availability_zones)
  vpc_id            = aws_vpc.this.id
  cidr_block        = local.private_subnets_cidr_block[count.index]
  availability_zone = local.availability_zones[count.index]

  tags = {
    Name = format(
      "nfw-private-%s",
      element(local.availability_zones, count.index),
    )
  }
}
