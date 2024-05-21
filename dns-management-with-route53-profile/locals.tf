locals {
  prefix             = "centraldns"
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]

  # ----------------------------------------------------------------------------------------------
  # VPC CIDR Block
  # ----------------------------------------------------------------------------------------------
  vpc_cidr_block_central_dns   = "10.1.0.0/16"
  vpc_cidr_block_onpremise     = "10.2.0.0/16"
  vpc_cidr_block_workload_app1 = "10.3.0.0/16"
  vpc_cidr_block_workload_app2 = "10.4.0.0/16"

  # ----------------------------------------------------------------------------------------------
  # VPC Subnet CIDR Block
  # ----------------------------------------------------------------------------------------------
  subnets_cidr_block_public_central_dns    = ["10.1.0.0/24", "10.1.1.0/24"]
  subnets_cidr_block_private_central_dns   = ["10.1.2.0/24", "10.1.3.0/24"]
  subnets_cidr_block_public_onpremise      = ["10.2.0.0/24", "10.2.1.0/24"]
  subnets_cidr_block_private_onpremise     = ["10.2.2.0/24", "10.2.3.0/24"]
  subnets_cidr_block_public_workload_app1  = ["10.3.0.0/24", "10.3.1.0/24"]
  subnets_cidr_block_private_workload_app1 = ["10.3.2.0/24", "10.3.3.0/24"]
  subnets_cidr_block_public_workload_app2  = ["10.4.0.0/24", "10.4.1.0/24"]
  subnets_cidr_block_private_workload_app2 = ["10.4.2.0/24", "10.4.3.0/24"]

  onpremise_dns_server_ip = "10.2.2.100"

  # ----------------------------------------------------------------------------------------------
  # AWS Route53 Resolver
  # ----------------------------------------------------------------------------------------------
  route53_resolver_inbound_endpoint_ip_addresses  = ["10.1.2.10", "10.1.3.10"]
  route53_resolver_outbound_endpoint_ip_addresses = ["10.1.2.20", "10.1.3.20"]
}
