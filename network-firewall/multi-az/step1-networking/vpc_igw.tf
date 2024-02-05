# ----------------------------------------------------------------------------------------------
# AWS Internet Gateway - DMZ
# ----------------------------------------------------------------------------------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.dmz.id

  tags = {
    Name = "${var.prefix}-dmz-igw"
  }
}