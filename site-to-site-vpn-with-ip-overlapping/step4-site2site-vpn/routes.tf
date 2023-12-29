# ----------------------------------------------------------------------------------------------
# AWS VPN Gateway Route Propagation for OnPremiseEU
# ----------------------------------------------------------------------------------------------
resource "aws_vpn_gateway_route_propagation" "onpremise_relay_eu" {
  vpn_gateway_id = aws_vpn_gateway.onpremise_relay_eu.id
  route_table_id = var.route_table_id_relay_eu
}

# ----------------------------------------------------------------------------------------------
# AWS VPN Gateway Route Propagation for OnPremiseUS
# ----------------------------------------------------------------------------------------------
resource "aws_vpn_gateway_route_propagation" "onpremise_relay_us" {
  vpn_gateway_id = aws_vpn_gateway.onpremise_relay_us.id
  route_table_id = var.route_table_id_relay_us
}

# ----------------------------------------------------------------------------------------------
# AWS VPN Gateway Route Propagation for OnPremiseJP
# ----------------------------------------------------------------------------------------------
resource "aws_vpn_gateway_route_propagation" "onpremise_relay_jp" {
  vpn_gateway_id = aws_vpn_gateway.onpremise_relay_jp.id
  route_table_id = var.route_table_id_relay_jp
}

# ----------------------------------------------------------------------------------------------
# OnPremiseEU Route Table
# ----------------------------------------------------------------------------------------------
resource "aws_route" "onpremise_eu" {
  route_table_id         = var.route_table_id_onpremise_eu
  destination_cidr_block = var.ip_cidr_relay_eu
  network_interface_id   = var.router_eni_id_eu
}

# ----------------------------------------------------------------------------------------------
# OnPremiseUS Route Table
# ----------------------------------------------------------------------------------------------
resource "aws_route" "onpremise_us" {
  route_table_id         = var.route_table_id_onpremise_us
  destination_cidr_block = var.ip_cidr_relay_us
  network_interface_id   = var.router_eni_id_us
}

# ----------------------------------------------------------------------------------------------
# OnPremiseJP Route Table
# ----------------------------------------------------------------------------------------------
resource "aws_route" "onpremise_jp" {
  route_table_id         = var.route_table_id_onpremise_jp
  destination_cidr_block = var.ip_cidr_relay_jp
  network_interface_id   = var.router_eni_id_jp
}

# ----------------------------------------------------------------------------------------------
# Relay EU Route Table
# ----------------------------------------------------------------------------------------------
resource "aws_route" "relay_eu" {
  route_table_id         = var.route_table_id_relay_eu
  destination_cidr_block = var.ip_cidr_onpremise_eu
  gateway_id             = aws_vpn_gateway.onpremise_relay_eu.id
}

# ----------------------------------------------------------------------------------------------
# Relay US Route Table
# ----------------------------------------------------------------------------------------------
resource "aws_route" "relay_us" {
  route_table_id         = var.route_table_id_relay_us
  destination_cidr_block = var.ip_cidr_onpremise_us
  gateway_id             = aws_vpn_gateway.onpremise_relay_us.id
}

