# ----------------------------------------------------------------------------------------------
# AWS Elastic IP
# ----------------------------------------------------------------------------------------------
resource "aws_eip" "this" {
  count = length(local.availability_zones)
  vpc   = true

  tags = {
    Name = format(
      "nfw-ip-%s",
      split("-", element(local.availability_zones, count.index))[2],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Nat Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_nat_gateway" "this" {
  count         = length(local.availability_zones)
  allocation_id = aws_eip.this[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = format(
      "nfw-natgw-%s",
      split("-", element(local.availability_zones, count.index))[2],
    )
  }
}
