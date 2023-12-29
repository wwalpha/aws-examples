
output "router_public_ip_onpremise_eu" {
  value = module.router_for_onpremise_eu.public_ip
}
output "router_public_ip_onpremise_us" {
  value = module.router_for_onpremise_us.public_ip
}
output "router_public_ip_onpremise_jp" {
  value = module.router_for_onpremise_jp.public_ip
}

output "server_public_ip_eu" {
  value = module.server_for_onpremise_eu.public_ip
}
output "server_public_ip_us" {
  value = module.server_for_onpremise_us.public_ip
}
output "server_public_ip_jp" {
  value = module.server_for_onpremise_jp.public_ip
}

output "proxy_private_ip_relay_eu" {
  value = module.proxy_for_relay_eu.private_ip
}
output "proxy_private_ip_relay_us" {
  value = module.proxy_for_relay_us.private_ip
}

output "nginx_private_ip_app" {
  value = module.aws_application.private_ip
}

output "router_eni_id_eu" {
  value = module.router_for_onpremise_eu.primary_network_interface_id
}
output "router_eni_id_us" {
  value = module.router_for_onpremise_us.primary_network_interface_id
}
output "router_eni_id_jp" {
  value = module.router_for_onpremise_jp.primary_network_interface_id
}

output "instance_id_router_eu" {
  value = module.router_for_onpremise_eu.id
}
output "instance_id_router_us" {
  value = module.router_for_onpremise_us.id
}
output "instance_id_router_jp" {
  value = module.router_for_onpremise_jp.id
}

output "relay_nlb_private_ip_eu" {
  value = one(aws_lb.relay_eu.subnet_mapping[*].private_ipv4_address)
}
output "relay_nlb_private_ip_us" {
  value = one(aws_lb.relay_us.subnet_mapping[*].private_ipv4_address)
}
output "relay_nlb_private_ip_jp" {
  value = one(aws_lb.relay_jp.subnet_mapping[*].private_ipv4_address)
}
