# ----------------------------------------------------------------------------------------------
# VPC - Central DNS
# ----------------------------------------------------------------------------------------------
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.prefix}-central-dns-vpc"
  }
}

# ----------------------------------------------------------------------------------------------
# VPC Subnets - Central DNS Private
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "this" {
  count = length(var.subnets_cidr_block)

  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.subnets_cidr_block, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.central_dns.tags.Name}-private-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}
