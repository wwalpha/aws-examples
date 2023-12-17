# ----------------------------------------------------------------------------------------------
# Customer Gateway for OnPremise EU
# ----------------------------------------------------------------------------------------------
resource "aws_customer_gateway" "onpremise_eu" {
  bgp_asn    = 65000
  ip_address = var.router_public_ip_onpremise_eu
  type       = "ipsec.1"
}

# ----------------------------------------------------------------------------------------------
# Customer Gateway for OnPremise US
# ----------------------------------------------------------------------------------------------
resource "aws_customer_gateway" "onpremise_us" {
  bgp_asn    = 65000
  ip_address = var.router_public_ip_onpremise_us
  type       = "ipsec.1"
}
