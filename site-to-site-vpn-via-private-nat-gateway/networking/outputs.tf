output "subnet_id_company_a" {
  value = module.company_a.public_subnets[0]
}

# output "subnet_id_company_b" {
#   value = module.company_b.public_subnets[0]
# }

output "subnet_id_aws_site" {
  value = module.aws_site.public_subnets[0]
}

output "vpc_id_company_a" {
  value = module.company_a.vpc_id
}

# output "vpc_id_company_b" {
#   value = module.company_b.vpc_id
# }

output "vpc_id_aws_site" {
  value = module.aws_site.vpc_id
}

output "route_table_id_aws_site" {
  value = module.aws_site.public_route_table_ids[0]
}

output "ip_cidr_company_a" {
  value = module.company_a.vpc_cidr_block
}

# output "ip_cidr_company_b" {
#   value = module.company_b.vpc_cidr_block
# }

output "ip_cidr_aws_site" {
  value = module.aws_site.vpc_cidr_block
}
