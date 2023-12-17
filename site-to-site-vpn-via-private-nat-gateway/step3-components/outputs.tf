
output "router_public_ip_onpremise_eu" {
  value = module.router_for_onpremise_eu.public_ip
}

output "router_public_ip_onpremise_us" {
  value = module.router_for_onpremise_us.public_ip
}

output "proxy_private_ip_relay_eu" {
  value = module.proxy_for_relay_eu.private_ip
}

output "proxy_private_ip_relay_us" {
  value = module.proxy_for_relay_us.private_ip
}

output "nginx_private_ip_app" {
  value = module.aws_nginx.private_ip
}

output "router_eni_id_onpremise_eu" {
  value = module.router_for_onpremise_eu.primary_network_interface_id
}
output "router_eni_id_onpremise_us" {
  value = module.router_for_onpremise_us.primary_network_interface_id
}


output "test" {
  value = module.router_for_onpremise_us
}
