output "windows_router_public_ip" {
  value = module.app.windows_router_public_ip
}

output "linux_router_public_ip" {
  value = module.app.linux_router_public_ip
}

output "company_a_tunnel1_ip" {
  value = module.site_to_site_vpn.company_a_tunnel1_ip
}

output "company_a_tunnel1_preshared_key" {
  value     = module.site_to_site_vpn.company_a_tunnel1_preshared_key
  sensitive = true
}

output "company_b_tunnel1_ip" {
  value = module.site_to_site_vpn.company_b_tunnel1_ip
}

output "company_b_tunnel2_preshared_key" {
  value     = module.site_to_site_vpn.company_a_tunnel1_preshared_key
  sensitive = true
}

# output "test" {
#   value = module.networking.test
# }
