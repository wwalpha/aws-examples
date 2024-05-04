locals {
  prefix             = "resolver"
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]

  vpc_cidr_block_central_dns   = "10.1.0.0/16"
  vpc_cidr_block_onpremise     = "10.2.0.0/16"
  vpc_cidr_block_workload_app1 = "10.3.0.0/16"
  vpc_cidr_block_workload_app2 = "10.4.0.0/16"

  subnets_cidr_block_public_central_dns    = ["10.1.0.0/24", "10.1.1.0/24"]
  subnets_cidr_block_private_central_dns   = ["10.1.2.0/24", "10.1.3.0/24"]
  subnets_cidr_block_public_onpremise      = ["10.2.0.0/24", "10.2.1.0/24"]
  subnets_cidr_block_private_onpremise     = ["10.2.2.0/24", "10.2.3.0/24"]
  subnets_cidr_block_public_workload_app1  = ["10.3.0.0/24", "10.3.1.0/24"]
  subnets_cidr_block_private_workload_app1 = ["10.3.2.0/24", "10.3.3.0/24"]
  subnets_cidr_block_public_workload_app2  = ["10.4.0.0/24", "10.4.1.0/24"]
  subnets_cidr_block_private_workload_app2 = ["10.4.2.0/24", "10.4.3.0/24"]

  aws_account_id_central_dns   = "999999999999"
  aws_account_id_onpremise     = "999999999999"
  aws_account_id_workload_app1 = "999999999999"
  aws_account_id_workload_app2 = "999999999999"

  aws_domain_name       = "master.aws"
  onpremise_domain_name = "master.local"
}
