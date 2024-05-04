# ----------------------------------------------------------------------------------------------
# VPC - Onpremise
# ----------------------------------------------------------------------------------------------
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.prefix}-onpremise-vpc"
  }
}

# ----------------------------------------------------------------------------------------------
# VPC Subnets - Onpremise (public)
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "public" {
  count = length(var.subnets_cidr_block_public)

  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.subnets_cidr_block_public, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.this.tags.Name}-public-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# VPC Subnets - Onpremise (private)
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "private" {
  count = length(var.subnets_cidr_block_private)

  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.subnets_cidr_block_private, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.this.tags.Name}-private-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}
