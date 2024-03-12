# ----------------------------------------------------------------------------------------------
# VPC - Central DNS
# ----------------------------------------------------------------------------------------------
resource "aws_vpc" "central_dns" {
  cidr_block           = local.vpc_cidr_block_central_dns
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.prefix}-central-dns-vpc"
  }
}

# ----------------------------------------------------------------------------------------------
# VPC - Workload1
# ----------------------------------------------------------------------------------------------
resource "aws_vpc" "workload1" {
  cidr_block           = local.vpc_cidr_block_workload1
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.prefix}-workload1-vpc"
  }
}

# ----------------------------------------------------------------------------------------------
# VPC - Workload2
# ----------------------------------------------------------------------------------------------
resource "aws_vpc" "workload2" {
  cidr_block           = local.vpc_cidr_block_workload2
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.prefix}-workload2-vpc"
  }
}
