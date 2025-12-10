# ----------------------------------------------------------------------------------------------
# VPC - Main VPC
# ----------------------------------------------------------------------------------------------
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

# ----------------------------------------------------------------------------------------------
# VPC - Internet Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-igw"
  })
}

# ----------------------------------------------------------------------------------------------
# Subnets - Public Subnet
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 0) # 10.0.0.0/24
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-public-subnet"
  })
}

# ----------------------------------------------------------------------------------------------
# Subnets - Private Subnet
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 1) # 10.0.1.0/24
  availability_zone = "${var.region}a"

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-private-subnet"
  })
}

# ----------------------------------------------------------------------------------------------
# Route Tables - Public Route Table
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-public-rt"
  })
}

# ----------------------------------------------------------------------------------------------
# Route Tables - Public Route Table Association
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ----------------------------------------------------------------------------------------------
# Route Tables - Private Route Table
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-private-rt"
  })
}

# ----------------------------------------------------------------------------------------------
# Route Tables - Private Route Table Association
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
