# ----------------------------------------------------------------------------------------------
# VPN Address for OnPremise EU
# ----------------------------------------------------------------------------------------------
output "tunnel_address_eu" {
  value = module.step4-site2site-vpn.tunnel_address_eu
}

# ----------------------------------------------------------------------------------------------
# VPN Address for OnPremise US
# ----------------------------------------------------------------------------------------------
output "tunnel_address_us" {
  value = module.step4-site2site-vpn.tunnel_address_us
}

# ----------------------------------------------------------------------------------------------
# VPN Address for OnPremise JP 
# ----------------------------------------------------------------------------------------------
output "tunnel_address_jp" {
  value = module.step4-site2site-vpn.tunnel_address_jp
}

# ----------------------------------------------------------------------------------------------
# Customer Gateway Address for OnPremise EU
# ----------------------------------------------------------------------------------------------
output "customer_gateway_address_eu" {
  value = module.step3-components.router_public_ip_onpremise_eu
}

# ----------------------------------------------------------------------------------------------
# Customer Gateway Address for OnPremise US
# ----------------------------------------------------------------------------------------------
output "customer_gateway_address_us" {
  value = module.step3-components.router_public_ip_onpremise_us
}

# ----------------------------------------------------------------------------------------------
# Customer Gateway Address for OnPremise JP
# ----------------------------------------------------------------------------------------------
output "customer_gateway_address_jp" {
  value = module.step3-components.router_public_ip_onpremise_jp
}

# ----------------------------------------------------------------------------------------------
# Server Address for OnPremise EU
# ----------------------------------------------------------------------------------------------
output "server_address_eu" {
  value = module.step3-components.server_public_ip_eu
}

# ----------------------------------------------------------------------------------------------
# Server Address for OnPremise US
# ----------------------------------------------------------------------------------------------
output "server_address_us" {
  value = module.step3-components.server_public_ip_us
}

# ----------------------------------------------------------------------------------------------
# Server Address for OnPremise JP
# ----------------------------------------------------------------------------------------------
output "server_address_jp" {
  value = module.step3-components.server_public_ip_jp
}

# ----------------------------------------------------------------------------------------------
# Relay NLB's Private IP of EU
# ----------------------------------------------------------------------------------------------
output "relay_nlb_private_ip_eu" {
  value = module.step3-components.relay_nlb_private_ip_eu
}
# ----------------------------------------------------------------------------------------------
# Relay NLB's Private IP of US
# ----------------------------------------------------------------------------------------------
output "relay_nlb_private_ip_us" {
  value = module.step3-components.relay_nlb_private_ip_us
}
# ----------------------------------------------------------------------------------------------
# Relay NLB's Private IP of JP
# ----------------------------------------------------------------------------------------------
output "relay_nlb_private_ip_jp" {
  value = module.step3-components.relay_nlb_private_ip_jp
}
