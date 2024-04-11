locals {
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]
  az_suffix          = [for az in local.availability_zones : split("-", az)[2]]

  vpc_cidr_block_central_dns             = "10.1.0.0/16"
  vpc_cidr_block_onpremise               = "10.10.0.0/16"
  subnets_cidr_block_central_dns_private = ["10.1.0.0/24", "10.1.1.0/24"]
  subnets_cidr_block_onpremise           = ["10.10.0.0/24", "10.10.1.0/24"]
}
