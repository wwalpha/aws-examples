# ----------------------------------------------------------------------------------------------
# AWS VPC
# ----------------------------------------------------------------------------------------------
resource "aws_vpc" "dmz" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.prefix}_dmz_vpc"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Internet Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_internet_gateway" "this" {
  tags = {
    Name = "${var.prefix}_igw"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Internet Gateway Attachment
# ----------------------------------------------------------------------------------------------
resource "aws_internet_gateway_attachment" "this" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id              = aws_vpc.this.id
}