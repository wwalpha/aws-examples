resource "aws_customer_gateway" "linux" {
  bgp_asn    = 65000
  ip_address = var.company_a_public_ip
  type       = "ipsec.1"
}

resource "aws_customer_gateway" "windows" {
  bgp_asn    = 65000
  ip_address = var.company_b_public_ip
  type       = "ipsec.1"
}

