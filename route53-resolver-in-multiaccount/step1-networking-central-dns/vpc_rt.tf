# ----------------------------------------------------------------------------------------------
# AWS Route Table - Central DNS
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "this" {
  depends_on = [aws_ec2_transit_gateway.this]
  vpc_id     = aws_vpc.this.id

  # 10.0.0.0/8 > Transit Gateway
  route {
    cidr_block         = local.vpc_cidr_block_cloud
    transit_gateway_id = aws_ec2_transit_gateway.this.id
  }

  tags = {
    Name = "${aws_vpc.this.tags.Name}-private-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Central DNS
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "this" {
  count          = length(aws_subnet.this[*].id)
  subnet_id      = element(aws_subnet.this[*].id, count.index)
  route_table_id = aws_route_table.this.id
}
