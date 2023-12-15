
output "linux_router_public_ip" {
  value = module.company_a_router.public_ip
}

output "windows_router_public_ip" {
  value = module.company_b_router.public_ip
}
