# ----------------------------------------------------------------------------------------------
# VPC Subnets - Ingress Public
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "ingress_public" {
  count = length(local.subnets_cidr_block_ingress_public)

  vpc_id            = aws_vpc.ingress.id
  cidr_block        = element(local.subnets_cidr_block_ingress_public, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.ingress.tags.Name}-public-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# VPC Subnets - Ingress TGW
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "ingress_tgw" {
  depends_on = [aws_vpc_ipv4_cidr_block_association.ingress]
  count      = length(local.subnets_cidr_block_ingress_tgw)

  vpc_id            = aws_vpc.ingress.id
  cidr_block        = element(local.subnets_cidr_block_ingress_tgw, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.ingress.tags.Name}-tgw-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# VPC Subnets - Egress Public
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "egress_public" {
  count = length(local.subnets_cidr_block_egress_public)

  vpc_id            = aws_vpc.egress.id
  cidr_block        = element(local.subnets_cidr_block_egress_public, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.egress.tags.Name}-public-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# VPC Subnets - Egress Firewall
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "egress_firewall" {
  count = length(local.subnets_cidr_block_egress_firewall)

  vpc_id            = aws_vpc.egress.id
  cidr_block        = element(local.subnets_cidr_block_egress_firewall, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.egress.tags.Name}-firewall-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# VPC Subnets - Egress TGW
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "egress_tgw" {
  depends_on = [aws_vpc_ipv4_cidr_block_association.egress]
  count      = length(local.subnets_cidr_block_egress_tgw)

  vpc_id            = aws_vpc.egress.id
  cidr_block        = element(local.subnets_cidr_block_egress_tgw, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.egress.tags.Name}-tgw-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# VPC Subnets - Inspection Firewall
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "inspection_firewall" {
  count = length(local.subnets_cidr_block_inspection_firewall)

  vpc_id            = aws_vpc.inspection.id
  cidr_block        = element(local.subnets_cidr_block_inspection_firewall, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.inspection.tags.Name}-firewall-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# VPC Subnets - Inspection TGW
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "inspection_tgw" {
  depends_on        = [aws_vpc_ipv4_cidr_block_association.ingress]
  count             = length(local.subnets_cidr_block_inspection_tgw)
  vpc_id            = aws_vpc.inspection.id
  cidr_block        = element(local.subnets_cidr_block_inspection_tgw, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.inspection.tags.Name}-tgw-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# VPC Subnets - Workload Intra Private
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "workload_intra_private" {
  count = length(local.subnets_cidr_block_workload_intra_private)

  vpc_id            = aws_vpc.workload_intra.id
  cidr_block        = element(local.subnets_cidr_block_workload_intra_private, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.workload_intra.tags.Name}-private-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# VPC Subnets - Workload Intra TGW
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "workload_intra_tgw" {
  depends_on        = [aws_vpc_ipv4_cidr_block_association.workload_intra]
  count             = length(local.subnets_cidr_block_workload_intra_tgw)
  vpc_id            = aws_vpc.workload_intra.id
  cidr_block        = element(local.subnets_cidr_block_workload_intra_tgw, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.workload_intra.tags.Name}-tgw-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# VPC Subnets - Workload Web Public
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "workload_web_public" {
  count = length(local.subnets_cidr_block_workload_web_public)

  vpc_id            = aws_vpc.workload_web.id
  cidr_block        = element(local.subnets_cidr_block_workload_web_public, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.workload_web.tags.Name}-public-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# VPC Subnets - Workload Web Private
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "workload_web_private" {
  count = length(local.subnets_cidr_block_workload_web_private)

  vpc_id            = aws_vpc.workload_web.id
  cidr_block        = element(local.subnets_cidr_block_workload_web_private, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.workload_web.tags.Name}-private-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# VPC Subnets - Workload Web TGW
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "workload_web_tgw" {
  depends_on        = [aws_vpc_ipv4_cidr_block_association.workload_web]
  count             = length(local.subnets_cidr_block_workload_web_tgw)
  vpc_id            = aws_vpc.workload_web.id
  cidr_block        = element(local.subnets_cidr_block_workload_web_tgw, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.workload_web.tags.Name}-tgw-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}
