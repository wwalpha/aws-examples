# ----------------------------------------------------------------------------------------------
# AWS Route Table - Onpremise
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "onpremise" {
  depends_on = [aws_ec2_transit_gateway.this]
  vpc_id     = aws_vpc.onpremise.id

  # 10.1.0.0/16 > Transit Gateway
  route {
    cidr_block         = local.vpc_cidr_block_central_dns
    transit_gateway_id = aws_ec2_transit_gateway.this.id
  }

  tags = {
    Name = "${aws_vpc.onpremise.tags.Name}-private-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Onpremise
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "onpremise" {
  count          = length(aws_subnet.onpremise[*].id)
  subnet_id      = element(aws_subnet.onpremise[*].id, count.index)
  route_table_id = aws_route_table.onpremise.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Central DNS
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "centraldns" {
  depends_on = [aws_ec2_transit_gateway.this]
  vpc_id     = aws_vpc.central_dns.id

  # 10.10.0.0/16 > Transit Gateway
  route {
    cidr_block         = local.vpc_cidr_block_onpremise
    transit_gateway_id = aws_ec2_transit_gateway.this.id
  }

  tags = {
    Name = "${aws_vpc.central_dns.tags.Name}-private-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Central DNS
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "centraldns" {
  count          = length(aws_subnet.central_dns_private[*].id)
  subnet_id      = element(aws_subnet.central_dns_private[*].id, count.index)
  route_table_id = aws_route_table.centraldns.id
}
