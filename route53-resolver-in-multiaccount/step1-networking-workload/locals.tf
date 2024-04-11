locals {
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]
  az_suffix          = [for az in local.availability_zones : split("-", az)[2]]

  vpc_cidr_block_workload             = "10.2.0.0/16"
  subnets_cidr_block_workload_private = ["10.2.0.0/24", "10.2.1.0/24"]
}
