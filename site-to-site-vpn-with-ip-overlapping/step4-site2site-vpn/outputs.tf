output "onpremise_eu_tunnel1_ip" {
  value = aws_vpn_connection.onpremise_relay_eu.tunnel1_address
}

output "onpremise_us_tunnel1_ip" {
  value = aws_vpn_connection.onpremise_relay_us.tunnel1_address
}
