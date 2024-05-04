# ----------------------------------------------------------------------------------------------
# VPC
# ----------------------------------------------------------------------------------------------
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.prefix}-vpc"
  }
}

# ----------------------------------------------------------------------------------------------
# VPC Subnets - Public
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
# VPC Subnets - Private
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

# ----------------------------------------------------------------------------------------------
# AWS Internet Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.prefix}-igw"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS EIP
# ----------------------------------------------------------------------------------------------
resource "aws_eip" "this" {
  depends_on = [aws_internet_gateway.this]
  count      = length(var.availability_zones)

  domain = "vpc"
  tags = {
    "Name" = format(
      "${var.prefix}-%s",
      element(var.availability_zones, count.index),
    )
  }
}

# ----------------------------------------------------------------------------------------------
# AWS NAT Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_nat_gateway" "this" {
  depends_on = [aws_internet_gateway.this]
  count      = length(var.availability_zones)

  allocation_id = element(aws_eip.this.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = {
    "Name" = format(
      "${var.prefix}-natgw-%s",
      element(var.availability_zones, count.index),
    )
  }
}
