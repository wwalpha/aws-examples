# ----------------------------------------------------------------------------------------------
# EC2 Private IP
# ----------------------------------------------------------------------------------------------
output "ec2_private_ip" {
  value = module.app.ec2_private_ip
}