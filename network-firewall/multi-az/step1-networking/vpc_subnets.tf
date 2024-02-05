# ----------------------------------------------------------------------------------------------
# VPC Subnets - DMZ Public
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "dmz_public" {
  count = length(local.cidr_block_dmz_subnets_public)

  vpc_id            = aws_vpc.dmz.id
  cidr_block        = element(local.cidr_block_dmz_subnets_public, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.dmz.tags.Name}-public-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# VPC Subnets - DMZ Firewall
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "dmz_firewall" {
  count = length(local.cidr_block_dmz_subnets_firewall)

  vpc_id            = aws_vpc.dmz.id
  cidr_block        = element(local.cidr_block_dmz_subnets_firewall, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.dmz.tags.Name}-firewall-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# VPC Subnets - DMZ Intra
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "dmz_intra" {
  count = length(local.cidr_block_dmz_subnets_intra)

  vpc_id            = aws_vpc.dmz.id
  cidr_block        = element(local.cidr_block_dmz_subnets_intra, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.dmz.tags.Name}-intra-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}
