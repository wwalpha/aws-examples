locals {
  prefix             = "resolver"
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]

  vpc_cidr_block_central_dns      = "10.1.0.0/16"
  vpc_cidr_block_onpremise        = "10.2.0.0/16"
  vpc_cidr_block_workload_public  = "10.3.0.0/16"
  vpc_cidr_block_workload_private = "10.4.0.0/16"

  subnets_cidr_block_central_dns             = ["10.1.0.0/24", "10.1.1.0/24"]
  subnets_cidr_block_onpremise               = ["10.2.0.0/24", "10.2.1.0/24"]
  subnets_cidr_block_public_workload_public  = ["10.3.0.0/24", "10.3.1.0/24"]
  subnets_cidr_block_private_workload_public = ["10.3.2.0/24", "10.3.3.0/24"]
  subnets_cidr_block_workload_private        = ["10.4.0.0/24", "10.4.1.0/24"]

  aws_account_id_central_dns      = "999999999999"
  aws_account_id_onpremise        = "999999999999"
  aws_account_id_workload_public  = "999999999999"
  aws_account_id_workload_private = "999999999999"
}
