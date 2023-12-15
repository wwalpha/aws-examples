resource "aws_vpn_connection" "company_a" {
  vpn_gateway_id      = aws_vpn_gateway.this.id
  customer_gateway_id = aws_customer_gateway.linux.id
  type                = "ipsec.1"
  static_routes_only  = true

  tags = {
    Name = "${var.prefix}-company-a"
  }
}

resource "aws_vpn_connection_route" "company_a_route" {
  destination_cidr_block = var.company_a_cidr
  vpn_connection_id      = aws_vpn_connection.company_a.id
}

resource "aws_vpn_connection" "company_b" {
  vpn_gateway_id      = aws_vpn_gateway.this.id
  customer_gateway_id = aws_customer_gateway.windows.id
  type                = "ipsec.1"
  static_routes_only  = true

  tags = {
    Name = "${var.prefix}-company-b"
  }
}

resource "aws_vpn_connection_route" "company_b_route" {
  destination_cidr_block = var.company_b_cidr
  vpn_connection_id      = aws_vpn_connection.company_b.id
}

