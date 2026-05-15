# ----------------------------------------------------------------------------------------------
# AWS VPC - Workload
# ----------------------------------------------------------------------------------------------
resource "aws_vpc" "workload" {
  cidr_block           = local.workload_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name_prefix}-workload-vpc"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Internet Gateway - Workload
# ----------------------------------------------------------------------------------------------
resource "aws_internet_gateway" "workload" {
  vpc_id = aws_vpc.workload.id

  tags = {
    Name = "${var.name_prefix}-workload-igw"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Subnet - Workload
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "workload" {
  for_each = local.workload_subnets

  vpc_id                  = aws_vpc.workload.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.name_prefix}-${replace(each.key, "_", "-")}"
  }
}
