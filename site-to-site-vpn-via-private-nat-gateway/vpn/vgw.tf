# ----------------------------------------------------------------------------------------------
# AWS Virtual Private Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_vpn_gateway" "this" {
  vpc_id = var.vpc_id_aws_site

  tags = {
    Name = "${var.prefix}-vgw"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Virtual Private Gateway Attachment
# ----------------------------------------------------------------------------------------------
resource "aws_vpn_gateway_attachment" "this" {
  vpc_id         = var.vpc_id_aws_site
  vpn_gateway_id = aws_vpn_gateway.this.id
}

# ----------------------------------------------------------------------------------------------
# AWS Virtual Private Gateway Attachment
# ----------------------------------------------------------------------------------------------
resource "aws_vpn_gateway_route_propagation" "this" {
  vpn_gateway_id = aws_vpn_gateway.this.id
  route_table_id = var.route_table_id_aws_site
}
