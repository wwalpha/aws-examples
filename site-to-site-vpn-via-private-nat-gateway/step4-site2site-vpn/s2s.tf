# ----------------------------------------------------------------------------------------------
# OnPremise EU and AWS Site to Site VPN
# ----------------------------------------------------------------------------------------------
resource "aws_vpn_connection" "onpremise_relay_eu" {
  depends_on               = [aws_customer_gateway.onpremise_eu]
  vpn_gateway_id           = aws_vpn_gateway.onpremise_relay_eu.id
  customer_gateway_id      = aws_customer_gateway.onpremise_eu.id
  type                     = "ipsec.1"
  static_routes_only       = true
  local_ipv4_network_cidr  = var.ip_cidr_onpremise_eu
  remote_ipv4_network_cidr = var.ip_cidr_relay_eu

  tags = {
    Name = "${var.prefix}-onpremise-relay-eu"
  }
}

# # ----------------------------------------------------------------------------------------------
# # OnPremise EU Side Route
# # ----------------------------------------------------------------------------------------------
# resource "aws_vpn_connection_route" "relay_to_onpremise_eu" {
#   destination_cidr_block = var.ip_cidr_onpremise_eu
#   vpn_connection_id      = aws_vpn_connection.onpremise_relay_eu.id
# }

# # ----------------------------------------------------------------------------------------------
# # Relay Side Route
# # ----------------------------------------------------------------------------------------------
# resource "aws_vpn_connection_route" "onpremise_to_relay_eu" {
#   destination_cidr_block = var.ip_cidr_relay_eu
#   vpn_connection_id      = aws_vpn_connection.onpremise_relay_eu.id
# }

# ----------------------------------------------------------------------------------------------
# OnPremise US and AWS Site to Site VPN
# ----------------------------------------------------------------------------------------------
resource "aws_vpn_connection" "onpremise_relay_us" {
  depends_on               = [aws_customer_gateway.onpremise_us]
  vpn_gateway_id           = aws_vpn_gateway.onpremise_relay_us.id
  customer_gateway_id      = aws_customer_gateway.onpremise_us.id
  type                     = "ipsec.1"
  static_routes_only       = true
  local_ipv4_network_cidr  = var.ip_cidr_onpremise_us
  remote_ipv4_network_cidr = var.ip_cidr_relay_us

  tags = {
    Name = "${var.prefix}-onpremise-relay-b"
  }
}

# # ----------------------------------------------------------------------------------------------
# # OnPremise US Side Route
# # ----------------------------------------------------------------------------------------------
# resource "aws_vpn_connection_route" "relay_to_onpremise_us" {
#   destination_cidr_block = var.ip_cidr_onpremise_us
#   vpn_connection_id      = aws_vpn_connection.onpremise_relay_us.id
# }

# # ----------------------------------------------------------------------------------------------
# # Relay Side Route
# # ----------------------------------------------------------------------------------------------
# resource "aws_vpn_connection_route" "onpremise_to_relay_us" {
#   destination_cidr_block = var.ip_cidr_relay_us
#   vpn_connection_id      = aws_vpn_connection.onpremise_relay_us.id
# }
