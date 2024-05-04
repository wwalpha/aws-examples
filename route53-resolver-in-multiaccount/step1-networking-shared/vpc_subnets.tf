# ----------------------------------------------------------------------------------------------
# VPC Subnets - Central DNS Private
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "central_dns_private" {
  count = length(local.subnets_cidr_block_central_dns_private)

  vpc_id            = aws_vpc.central_dns.id
  cidr_block        = element(local.subnets_cidr_block_central_dns_private, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.central_dns.tags.Name}-private-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# VPC Subnets - Onpremise
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "onpremise" {
  count = length(local.subnets_cidr_block_onpremise)

  vpc_id            = aws_vpc.onpremise.id
  cidr_block        = element(local.subnets_cidr_block_onpremise, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.onpremise.tags.Name}-private-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}
