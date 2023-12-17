# ----------------------------------------------------------------------------------------------
# AWS Virtual Private Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_vpn_gateway" "onpremise_eu" {
  vpc_id = module.onpremise_eu_vpc.vpc_id

  tags = {
    Name = "${var.prefix}-vgw-onpremise-a"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Virtual Private Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_vpn_gateway" "onpremise_us" {
  vpc_id = module.onpremise_us_vpc.vpc_id

  tags = {
    Name = "${var.prefix}-vgw-onpremise-a"
  }
}

