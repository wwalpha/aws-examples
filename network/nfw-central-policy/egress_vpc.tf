# ----------------------------------------------------------------------------------------------
# AWS VPC - Egress
# ----------------------------------------------------------------------------------------------
resource "aws_vpc" "egress" {
  cidr_block           = local.egress_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name_prefix}-egress-vpc"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Internet Gateway - Egress
# ----------------------------------------------------------------------------------------------
resource "aws_internet_gateway" "egress" {
  vpc_id = aws_vpc.egress.id

  tags = {
    Name = "${var.name_prefix}-egress-igw"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Subnet - Egress
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "egress" {
  for_each = local.egress_subnets

  vpc_id                  = aws_vpc.egress.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.name_prefix}-egress-${replace(each.key, "_", "-")}"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Elastic IP - Egress NAT
# ----------------------------------------------------------------------------------------------
resource "aws_eip" "egress_nat" {
  domain = "vpc"

  tags = {
    Name = "${var.name_prefix}-egress-nat-eip"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS NAT Gateway - Egress
# ----------------------------------------------------------------------------------------------
resource "aws_nat_gateway" "egress" {
  allocation_id = aws_eip.egress_nat.id
  subnet_id     = aws_subnet.egress["nat_public_a"].id

  depends_on = [aws_internet_gateway.egress]

  tags = {
    Name = "${var.name_prefix}-egress-natgw"
  }
}
