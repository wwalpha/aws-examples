
output "subnet_id_onpremise_eu" {
  value = module.onpremise_eu_vpc.public_subnets[0]
}
output "subnet_id_onpremise_us" {
  value = module.onpremise_us_vpc.public_subnets[0]
}
output "subnet_id_aws_relay_eu" {
  value = module.relay_vpc_for_eu.public_subnets[0]
}
output "subnet_id_aws_relay_us" {
  value = module.relay_vpc_for_us.public_subnets[0]
}
output "subnet_id_aws_app" {
  value = module.aws_app_vpc.public_subnets[0]
}

output "vpc_id_onpremise_eu" {
  value = module.onpremise_eu_vpc.vpc_id
}
output "vpc_id_onpremise_us" {
  value = module.onpremise_us_vpc.vpc_id
}
output "vpc_id_aws_relay_eu" {
  value = module.relay_vpc_for_eu.vpc_id
}
output "vpc_id_aws_relay_us" {
  value = module.relay_vpc_for_us.vpc_id
}
output "vpc_id_aws_app" {
  value = module.aws_app_vpc.vpc_id
}

output "ip_cidr_onpremise_eu" {
  value = module.onpremise_eu_vpc.vpc_cidr_block
}
output "ip_cidr_onpremise_us" {
  value = module.onpremise_us_vpc.vpc_cidr_block
}
output "ip_cidr_relay_eu" {
  value = module.relay_vpc_for_eu.vpc_cidr_block
}
output "ip_cidr_relay_us" {
  value = module.relay_vpc_for_us.vpc_cidr_block
}
output "ip_cidr_aws_app" {
  value = module.aws_app_vpc.vpc_cidr_block
}

output "route_table_id_onpremise_eu" {
  value = module.onpremise_eu_vpc.public_route_table_ids[0]
}
output "route_table_id_onpremise_us" {
  value = module.onpremise_us_vpc.public_route_table_ids[0]
}
output "route_table_id_relay_eu" {
  value = module.relay_vpc_for_eu.public_route_table_ids[0]
}
output "route_table_id_relay_us" {
  value = module.relay_vpc_for_us.public_route_table_ids[0]
}

output "test" {
  value = module.relay_vpc_for_us
}
