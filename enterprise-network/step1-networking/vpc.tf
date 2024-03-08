# ----------------------------------------------------------------------------------------------
# VPC - Ingress
# ----------------------------------------------------------------------------------------------
resource "aws_vpc" "ingress" {
  cidr_block           = local.vpc_cidr_block_ingress
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.prefix}-ingress-vpc"
  }
}

# ----------------------------------------------------------------------------------------------
# VPC IPV4 CIDR Block Association - Ingress
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_ipv4_cidr_block_association" "ingress" {
  vpc_id     = aws_vpc.ingress.id
  cidr_block = local.vpc_cidr_block_tgw_for_ingress
}

# ----------------------------------------------------------------------------------------------
# VPC - Egress
# ----------------------------------------------------------------------------------------------
resource "aws_vpc" "egress" {
  cidr_block           = local.vpc_cidr_block_egress
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.prefix}-egress-vpc"
  }
}

# ----------------------------------------------------------------------------------------------
# VPC IPV4 CIDR Block Association - Egress
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_ipv4_cidr_block_association" "egress" {
  vpc_id     = aws_vpc.egress.id
  cidr_block = local.vpc_cidr_block_tgw_for_egress
}

# ----------------------------------------------------------------------------------------------
# VPC - Inspection
# ----------------------------------------------------------------------------------------------
resource "aws_vpc" "inspection" {
  cidr_block           = local.vpc_cidr_block_inspection
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.prefix}-inspection-vpc"
  }
}

# ----------------------------------------------------------------------------------------------
# VPC IPV4 CIDR Block Association - Inspection
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_ipv4_cidr_block_association" "inspection" {
  vpc_id     = aws_vpc.inspection.id
  cidr_block = local.vpc_cidr_block_tgw_for_inspection
}

# ----------------------------------------------------------------------------------------------
# VPC - Workload
# ----------------------------------------------------------------------------------------------
resource "aws_vpc" "workload" {
  cidr_block           = local.vpc_cidr_block_workload
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.prefix}-workload-vpc"
  }
}

# ----------------------------------------------------------------------------------------------
# VPC IPV4 CIDR Block Association - Workload
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_ipv4_cidr_block_association" "workload" {
  vpc_id     = aws_vpc.workload.id
  cidr_block = local.vpc_cidr_block_tgw_for_workload
}
