locals {
  firewall_endpoints          = flatten(aws_networkfirewall_firewall.this.firewall_status[*].sync_states[*].*.attachment[*])[*].endpoint_id
  availability_zones          = ["ap-northeast-1a"]
  private_subnets_cidr_block  = ["10.0.0.0/24"]
  firewall_subnets_cidr_block = ["10.0.1.0/24"]
}
