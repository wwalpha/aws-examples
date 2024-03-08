# ----------------------------------------------------------------------------------------------
# AWS Internet Gateway - Ingress
# ----------------------------------------------------------------------------------------------
resource "aws_internet_gateway" "ingress" {
  vpc_id = aws_vpc.ingress.id

  tags = {
    Name = "${var.prefix}-ingress-igw"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Internet Gateway - Egress
# ----------------------------------------------------------------------------------------------
resource "aws_internet_gateway" "egress" {
  vpc_id = aws_vpc.egress.id

  tags = {
    Name = "${var.prefix}-egress-igw"
  }
}
