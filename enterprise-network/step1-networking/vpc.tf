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
  depends_on = [aws_vpc.ingress]
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
  depends_on = [aws_vpc.egress]
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
  depends_on = [aws_vpc.inspection]
  vpc_id     = aws_vpc.inspection.id
  cidr_block = local.vpc_cidr_block_tgw_for_inspection
}

# ----------------------------------------------------------------------------------------------
# VPC - Workload Intra
# ----------------------------------------------------------------------------------------------
resource "aws_vpc" "workload_intra" {
  cidr_block           = local.vpc_cidr_block_workload_intra
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.prefix}-workload-intra-vpc"
  }
}

# ----------------------------------------------------------------------------------------------
# VPC IPV4 CIDR Block Association - Workload Intra
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_ipv4_cidr_block_association" "workload_intra" {
  depends_on = [aws_vpc.workload_intra]
  vpc_id     = aws_vpc.workload_intra.id
  cidr_block = local.vpc_cidr_block_tgw_for_workload_intra
}


# ----------------------------------------------------------------------------------------------
# VPC - Workload B
# ----------------------------------------------------------------------------------------------
resource "aws_vpc" "workload_web" {
  cidr_block           = local.vpc_cidr_block_workload_web
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.prefix}-workload-web-vpc"
  }
}

# ----------------------------------------------------------------------------------------------
# VPC IPV4 CIDR Block Association - Workload Web
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_ipv4_cidr_block_association" "workload_web" {
  depends_on = [aws_vpc.workload_web]
  vpc_id     = aws_vpc.workload_web.id
  cidr_block = local.vpc_cidr_block_tgw_for_workload_web
}
