# ----------------------------------------------------------------------------------------------
# AWS VPC ID - DMZ VPC
# ----------------------------------------------------------------------------------------------
output "vpc_id_dmz" {
  value = aws_vpc.dmz.id
}

# ----------------------------------------------------------------------------------------------
# AWS VPC ID - APP VPC
# ----------------------------------------------------------------------------------------------
output "vpc_id_app" {
  value = module.app_vpc.vpc_id
}

# ----------------------------------------------------------------------------------------------
# VPC Subnets - App Private Subnets
# ----------------------------------------------------------------------------------------------
output "vpc_subnets_app_private" {
  value = module.app_vpc.private_subnets
}

# ----------------------------------------------------------------------------------------------
# VPC Subnets - DMZ Intra Subnets
# ----------------------------------------------------------------------------------------------
output "vpc_subnets_dmz_intra" {
  value = aws_subnet.dmz_intra[*].id
}
