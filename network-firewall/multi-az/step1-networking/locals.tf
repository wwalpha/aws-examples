locals {
  firewall_endpoints = flatten(aws_networkfirewall_firewall.this.firewall_status[*].sync_states[*].*.attachment[*])[*].endpoint_id
  availability_zones = ["ap-northeast-1a", "ap-northeast-1d"]
  az_suffix          = [for az in local.availability_zones : split("-", az)[2]]


  cidr_block_dmz_subnets_public   = ["10.10.0.0/24", "10.10.1.0/24"]
  cidr_block_dmz_subnets_firewall = ["10.10.2.0/24", "10.10.3.0/24"]
  cidr_block_dmz_subnets_intra    = ["10.10.4.0/24", "10.10.5.0/24"]
  cidr_block_app_subnets_private  = ["10.20.0.0/24", "10.20.1.0/24"]
  cidr_block_tgw                  = ["10.99.0.0/24"]
  cidr_block_aws_cloud            = "10.0.0.0/8"

  vpc_cidr_block_dmz = "10.10.0.0/16"
  vpc_cidr_block_app = "10.20.0.0/16"
}
