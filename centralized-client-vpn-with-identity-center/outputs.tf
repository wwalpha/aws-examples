output "ec2_private_ip_01" {
  value = module.server01.private_ip
}

output "ec2_private_ip_02" {
  value = module.server02.private_ip
}
