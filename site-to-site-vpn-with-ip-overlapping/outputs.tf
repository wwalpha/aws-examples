# ----------------------------------------------------------------------------------------------
# VPN Address for OnPremise EU
# ----------------------------------------------------------------------------------------------
output "tunnel_address_for_onpremise_eu" {
  value = module.step4-site2site-vpn.tunnel_address_for_onpremise_eu
}

# ----------------------------------------------------------------------------------------------
# VPN Address for OnPremise US
# ----------------------------------------------------------------------------------------------
output "tunnel_address_for_onpremise_us" {
  value = module.step4-site2site-vpn.tunnel_address_for_onpremise_us
}

# ----------------------------------------------------------------------------------------------
# VPN Address for OnPremise JP 
# ----------------------------------------------------------------------------------------------
output "tunnel_address_for_onpremise_jp" {
  value = module.step4-site2site-vpn.tunnel_address_for_onpremise_jp
}

# ----------------------------------------------------------------------------------------------
# Customer Gateway Address for OnPremise EU
# ----------------------------------------------------------------------------------------------
output "customer_gateway_address_for_eu" {
  value = module.step3-components.router_public_ip_onpremise_eu
}

# ----------------------------------------------------------------------------------------------
# Customer Gateway Address for OnPremise US
# ----------------------------------------------------------------------------------------------
output "customer_gateway_address_for_us" {
  value = module.step3-components.router_public_ip_onpremise_us
}

# ----------------------------------------------------------------------------------------------
# Customer Gateway Address for OnPremise JP
# ----------------------------------------------------------------------------------------------
output "customer_gateway_address_for_jp" {
  value = module.step3-components.router_public_ip_onpremise_jp
}

