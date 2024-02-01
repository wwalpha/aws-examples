locals {
  firewall_endpoints = flatten(aws_networkfirewall_firewall.this.firewall_status[*].sync_states[*].*.attachment[*])[*].endpoint_id
  # firewall_subnet_ids = flatten(aws_networkfirewall_firewall.this.firewall_status[*].sync_states[*].*.attachment[*])[*].subnet_id
  # firewall_zones      = { for obj in flatten(aws_networkfirewall_firewall.this.firewall_status[*].sync_states[*].*) : obj.availability_zone => obj.attachment[0].endpoint_id }

  availability_zones = ["ap-northeast-1a", "ap-northeast-1d"]

  private_subnets_cidr_block  = ["10.10.0.0/24", "10.10.1.0/24"]
  firewall_subnets_cidr_block = ["10.10.2.0/24", "10.10.3.0/24"]
  public_subnets_cidr_block   = ["10.10.4.0/24", "10.10.5.0/24"]
}
