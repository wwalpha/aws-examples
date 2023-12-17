# ----------------------------------------------------------------------------------------------
# AWS Virtual Private Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_vpn_gateway" "onpremise_a" {
  vpc_id = module.onpremise_a_vpc.vpc_id

  tags = {
    Name = "${var.prefix}-vgw-onpremise-a"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Virtual Private Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_vpn_gateway" "onpremise_b" {
  vpc_id = module.onpremise_b_vpc.vpc_id

  tags = {
    Name = "${var.prefix}-vgw-onpremise-a"
  }
}

