# ----------------------------------------------------------------------------------------------
# AWS Virtual Private Gateway for OnPremise EU
# ----------------------------------------------------------------------------------------------
resource "aws_vpn_gateway" "onpremise_relay_eu" {
  vpc_id = var.vpc_id_relay_eu

  tags = {
    Name = "${var.prefix}-vgw-onpremise-eu"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Virtual Private Gateway Attachment for OnPremise EU
# ----------------------------------------------------------------------------------------------
resource "aws_vpn_gateway_attachment" "onpremise_relay_eu" {
  vpc_id         = var.vpc_id_relay_eu
  vpn_gateway_id = aws_vpn_gateway.onpremise_relay_eu.id
}

# ----------------------------------------------------------------------------------------------
# AWS VPN Gateway Route Propagation for OnPremiseEU
# ----------------------------------------------------------------------------------------------
# resource "aws_vpn_gateway_route_propagation" "onpremise_relay_eu" {
#   vpn_gateway_id = aws_vpn_gateway.onpremise_relay_eu.id
#   route_table_id = var.route_table_id_aws_site
# }

# ----------------------------------------------------------------------------------------------
# AWS Virtual Private Gateway for OnPremise US
# ----------------------------------------------------------------------------------------------
resource "aws_vpn_gateway" "onpremise_relay_us" {
  vpc_id = var.vpc_id_relay_us

  tags = {
    Name = "${var.prefix}-vgw-onpremise-us"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Virtual Private Gateway Attachment for OnPremise US
# ----------------------------------------------------------------------------------------------
resource "aws_vpn_gateway_attachment" "onpremise_relay_us" {
  vpc_id         = var.vpc_id_relay_us
  vpn_gateway_id = aws_vpn_gateway.onpremise_relay_us.id
}

# ----------------------------------------------------------------------------------------------
# AWS VPN Gateway Route Propagation for OnPremiseEU
# ----------------------------------------------------------------------------------------------
# resource "aws_vpn_gateway_route_propagation" "onpremise_relay_eu" {
#   vpn_gateway_id = aws_vpn_gateway.onpremise_relay_eu.id
#   route_table_id = var.route_table_id_aws_site
# }
