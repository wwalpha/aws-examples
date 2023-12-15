output "company_a_tunnel1_ip" {
  value = aws_vpn_connection.company_a.tunnel1_address
}

output "company_a_tunnel1_preshared_key" {
  value = aws_vpn_connection.company_a.tunnel1_preshared_key
}

# output "company_b_tunnel1_ip" {
#   value = aws_vpn_connection.company_b.tunnel1_address
# }

# output "company_b_tunnel1_preshared_key" {
#   value = aws_vpn_connection.company_b.tunnel1_preshared_key
# }
