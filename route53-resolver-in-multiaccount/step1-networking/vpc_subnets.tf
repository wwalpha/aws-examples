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
# VPC Subnets - Workload1
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "workload1" {
  count = length(local.subnets_cidr_block_workload1_private)

  vpc_id            = aws_vpc.workload1.id
  cidr_block        = element(local.subnets_cidr_block_workload1_private, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.workload1.tags.Name}-private-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# VPC Subnets - Workload2
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "workload2" {
  count = length(local.subnets_cidr_block_workload2_private)

  vpc_id            = aws_vpc.workload2.id
  cidr_block        = element(local.subnets_cidr_block_workload2_private, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.workload2.tags.Name}-private-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}
