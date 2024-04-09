locals {
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]
  az_suffix          = [for az in local.availability_zones : split("-", az)[2]]

  vpc_cidr_block_central_dns = "10.1.0.0/16"
  vpc_cidr_block_workload    = "10.2.0.0/16"
  vpc_cidr_block_onpremise   = "10.10.0.0/16"
  # vpc_cidr_block_workload1   = "10.2.0.0/16"
  # vpc_cidr_block_workload2   = "10.3.0.0/16"
  subnets_cidr_block_central_dns_private = ["10.1.0.0/24", "10.1.1.0/24"]
  subnets_cidr_block_workload_private    = ["10.2.0.0/24", "10.2.1.0/24"]
  subnets_cidr_block_onpremise           = ["10.10.0.0/24", "10.10.1.0/24"]
  # subnets_cidr_block_workload1_private   = ["10.2.0.0/24", "10.2.1.0/24"]
  # subnets_cidr_block_workload2_private   = ["10.3.0.0/24", "10.3.1.0/24"]
}
