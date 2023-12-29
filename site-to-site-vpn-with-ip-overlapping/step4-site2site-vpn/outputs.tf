output "tunnel_address_eu" {
  value = aws_vpn_connection.onpremise_relay_eu.tunnel1_address
}

output "tunnel_address_us" {
  value = aws_vpn_connection.onpremise_relay_us.tunnel1_address
}

output "tunnel_address_jp" {
  value = aws_vpn_connection.onpremise_relay_jp.tunnel1_address
}

output "s2s_psk_key_eu" {
  value = aws_vpn_connection.onpremise_relay_eu.tunnel1_preshared_key
}
output "s2s_psk_key_us" {
  value = aws_vpn_connection.onpremise_relay_us.tunnel1_preshared_key
}
output "s2s_psk_key_jp" {
  value = aws_vpn_connection.onpremise_relay_jp.tunnel1_preshared_key
}
