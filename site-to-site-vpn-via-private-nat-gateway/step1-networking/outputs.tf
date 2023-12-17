
output "subnet_id_onpremise_a" {
  value = module.onpremise_a_vpc.public_subnets[0]
}
output "subnet_id_onpremise_b" {
  value = module.onpremise_b_vpc.public_subnets[0]
}
output "subnet_id_aws_relay_a" {
  value = module.aws_relay_vpc_for_a.public_subnets[0]
}
output "subnet_id_aws_relay_b" {
  value = module.aws_relay_vpc_for_b.public_subnets[0]
}
output "subnet_id_aws_app" {
  value = module.aws_app_vpc.public_subnets[0]
}

output "vpc_id_onpremise_a" {
  value = module.onpremise_a_vpc.vpc_id
}
output "vpc_id_onpremise_b" {
  value = module.onpremise_b_vpc.vpc_id
}
output "vpc_id_aws_relay_a" {
  value = module.aws_relay_vpc_for_a.vpc_id
}
output "vpc_id_aws_relay_b" {
  value = module.aws_relay_vpc_for_b.vpc_id
}
output "vpc_id_aws_app" {
  value = module.aws_app_vpc.vpc_id
}

output "router_public_ip_onpremise_eu" {
  value = module.onpremise_a_vpc.router_public_ip
}
output "router_public_ip_onpremise_us" {
  value = module.onpremise_b_vpc.router_public_ip
}
