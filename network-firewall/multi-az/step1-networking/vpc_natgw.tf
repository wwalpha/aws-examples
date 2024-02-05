# ----------------------------------------------------------------------------------------------
# AWS EIP - DMZ
# ----------------------------------------------------------------------------------------------
resource "aws_eip" "nat" {
  depends_on = [aws_internet_gateway.this]
  count      = length(local.availability_zones)

  domain = "vpc"
  tags = {
    "Name" = format(
      "${var.prefix}-%s",
      element(local.availability_zones, count.index),
    )
  }
}

# ----------------------------------------------------------------------------------------------
# AWS NAT Gateway - DMZ
# ----------------------------------------------------------------------------------------------
resource "aws_nat_gateway" "this" {
  depends_on = [aws_internet_gateway.this]
  count      = length(local.availability_zones)

  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.dmz_public.*.id, count.index)

  tags = {
    "Name" = format(
      "${var.prefix}-natgw-%s",
      element(local.availability_zones, count.index),
    )
  }
}
