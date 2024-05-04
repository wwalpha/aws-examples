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
# VPC - Onpremise
# ----------------------------------------------------------------------------------------------
resource "aws_vpc" "onpremise" {
  cidr_block           = local.vpc_cidr_block_onpremise
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.prefix}-onpremise-vpc"
  }
}
