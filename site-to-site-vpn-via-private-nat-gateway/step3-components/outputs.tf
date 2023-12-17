
output "router_public_ip_onpremise_a" {
  value = module.router_for_onpremise_a.public_ip
}

output "router_public_ip_onpremise_b" {
  value = module.router_for_onpremise_b.public_ip
}

output "proxy_private_ip_relay_a" {
  value = module.proxy_for_relay_a.private_ip
}

output "proxy_private_ip_relay_b" {
  value = module.proxy_for_relay_b.private_ip
}

output "nginx_private_ip_app" {
  value = module.aws_nginx.private_ip
}
