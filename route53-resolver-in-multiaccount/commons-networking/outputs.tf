# ----------------------------------------------------------------------------------------------
# AWS VPC ID - VPC
# ----------------------------------------------------------------------------------------------
output "vpc_id" {
  value = module.vpc.vpc_id
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Subnets - Private Subnets
# ----------------------------------------------------------------------------------------------
output "vpc_public_subnet_ids" {
  value = module.vpc.public_subnets
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Subnets - Private Subnets
# ----------------------------------------------------------------------------------------------
output "vpc_private_subnet_ids" {
  value = module.vpc.private_subnets
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway Attachment Id
# ----------------------------------------------------------------------------------------------
output "transit_gateway_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.this.id
}

# ----------------------------------------------------------------------------------------------
# AWS Private Subnet Route Table Ids
# ----------------------------------------------------------------------------------------------
output "vpc_private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}
