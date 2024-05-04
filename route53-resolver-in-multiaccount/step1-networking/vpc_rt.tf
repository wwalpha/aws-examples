# ----------------------------------------------------------------------------------------------
# AWS Route Table - Private
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "private" {
  depends_on = [aws_ram_resource_share_accepter.this, aws_nat_gateway.this]
  vpc_id     = aws_vpc.this.id

  # 10.0.0.0/8 > Transit Gateway
  route {
    cidr_block         = local.vpc_cidr_block_cloud
    transit_gateway_id = var.transit_gateway_id
  }

  route {
    cidr_block     = local.vpc_cidr_block_any
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name = "${aws_vpc.this.tags.Name}-private-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Private
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private[*].id)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Public
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = local.vpc_cidr_block_any
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${aws_vpc.this.tags.Name}-public-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Public
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public[*].id)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

