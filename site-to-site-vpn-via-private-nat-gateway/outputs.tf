output "onpremise_eu_tunnel1_ip" {
  value = module.step4-site2site-vpn.onpremise_eu_tunnel1_ip
}

output "onpremise_us_tunnel1_ip" {
  value = module.step4-site2site-vpn.onpremise_us_tunnel1_ip
}

# output "company_a_tunnel1_preshared_key" {
#   value     = module.site_to_site_vpn.company_a_tunnel1_preshared_key
#   sensitive = true
# }

# output "company_b_tunnel1_ip" {
#   value = module.site_to_site_vpn.company_b_tunnel1_ip
# }

# output "company_b_tunnel1_preshared_key" {
#   value     = module.site_to_site_vpn.company_b_tunnel1_preshared_key
#   sensitive = true
# }
