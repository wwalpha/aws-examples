locals {
  firewall_endpoints_inspection = flatten(aws_networkfirewall_firewall.inspection.firewall_status[*].sync_states[*].*.attachment[*])[*].endpoint_id
  firewall_endpoints_egress     = flatten(aws_networkfirewall_firewall.egress.firewall_status[*].sync_states[*].*.attachment[*])[*].endpoint_id
  availability_zones            = ["ap-northeast-1a", "ap-northeast-1c"]
  az_suffix                     = [for az in local.availability_zones : split("-", az)[2]]

  vpc_cidr_block_ingress            = "10.0.0.0/16"
  vpc_cidr_block_egress             = "10.1.0.0/16"
  vpc_cidr_block_inspection         = "10.2.0.0/16"
  vpc_cidr_block_workload_a         = "10.3.0.0/16"
  vpc_cidr_block_workload_b         = "10.4.0.0/16"
  vpc_cidr_block_tgw_for_ingress    = "10.5.0.0/27"
  vpc_cidr_block_tgw_for_egress     = "10.5.0.32/27"
  vpc_cidr_block_tgw_for_inspection = "10.5.0.64/27"
  vpc_cidr_block_tgw_for_workload_a = "10.5.0.96/28"
  vpc_cidr_block_tgw_for_workload_b = "10.5.0.112/28"
  cidr_block_tgw                    = "10.6.0.0/16"
  cidr_block_internet               = "0.0.0.0/0"
  cidr_block_awscloud               = "10.0.0.0/8"
  cidr_block_datacenter             = "192.168.0.0/16"

  subnets_cidr_block_ingress_public      = ["10.0.0.0/24", "10.0.1.0/24"]
  subnets_cidr_block_egress_public       = ["10.1.0.0/24", "10.1.1.0/24"]
  subnets_cidr_block_egress_firewall     = ["10.1.2.0/24", "10.1.3.0/24"]
  subnets_cidr_block_inspection_firewall = ["10.2.0.0/24", "10.2.1.0/24"]
  subnets_cidr_block_workload_a_private  = ["10.3.0.0/24"]
  subnets_cidr_block_workload_b_private  = ["10.4.0.0/24"]
  subnets_cidr_block_ingress_tgw         = ["10.4.0.0/28", "10.4.0.16/28"]
  subnets_cidr_block_egress_tgw          = ["10.4.0.32/28", "10.4.0.48/28"]
  subnets_cidr_block_inspection_tgw      = ["10.4.0.64/28", "10.4.0.80/28"]
  subnets_cidr_block_workload_a_tgw      = ["10.4.0.96/28"]
  subnets_cidr_block_workload_b_tgw      = ["10.4.0.112/28"]
}
