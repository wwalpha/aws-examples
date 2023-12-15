# ----------------------------------------------------------------------------------------------
# Company A and AWS Site to Site VPN
# ----------------------------------------------------------------------------------------------
resource "aws_vpn_connection" "company_a" {
  depends_on               = [aws_customer_gateway.linux]
  vpn_gateway_id           = aws_vpn_gateway.this.id
  customer_gateway_id      = aws_customer_gateway.linux.id
  type                     = "ipsec.1"
  static_routes_only       = true
  local_ipv4_network_cidr  = var.ip_cidr_company_a
  remote_ipv4_network_cidr = var.ip_cidr_aws_site

  tags = {
    Name = "${var.prefix}-company-a"
  }
}

# ----------------------------------------------------------------------------------------------
# Company A Side Route
# ----------------------------------------------------------------------------------------------
resource "aws_vpn_connection_route" "company_a_to_aws" {
  destination_cidr_block = var.ip_cidr_company_a
  vpn_connection_id      = aws_vpn_connection.company_a.id
}

# ----------------------------------------------------------------------------------------------
# AWS Side Route
# ----------------------------------------------------------------------------------------------
resource "aws_vpn_connection_route" "aws_to_company_a" {
  destination_cidr_block = var.ip_cidr_aws_site
  vpn_connection_id      = aws_vpn_connection.company_a.id
}

# # ----------------------------------------------------------------------------------------------
# # Company B and AWS Site to Site VPN
# # ----------------------------------------------------------------------------------------------
# resource "aws_vpn_connection" "company_b" {
#   depends_on               = [aws_customer_gateway.windows]
#   vpn_gateway_id           = aws_vpn_gateway.this.id
#   customer_gateway_id      = aws_customer_gateway.windows.id
#   type                     = "ipsec.1"
#   static_routes_only       = true
#   local_ipv4_network_cidr  = var.ip_cidr_company_b
#   remote_ipv4_network_cidr = var.ip_cidr_aws_site

#   tags = {
#     Name = "${var.prefix}-company-b"
#   }
# }

# # ----------------------------------------------------------------------------------------------
# # Company B Site to Site VPN Route
# # ----------------------------------------------------------------------------------------------
# resource "aws_vpn_connection_route" "company_b_to_aws" {
#   destination_cidr_block = var.ip_cidr_company_b
#   vpn_connection_id      = aws_vpn_connection.company_b.id
# }

# # ----------------------------------------------------------------------------------------------
# # AWS Side Route
# # ----------------------------------------------------------------------------------------------
# resource "aws_vpn_connection_route" "aws_to_company_b" {
#   destination_cidr_block = var.ip_cidr_aws_site
#   vpn_connection_id      = aws_vpn_connection.company_b.id
# }
