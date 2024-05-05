# ----------------------------------------------------------------------------------------------
# RAM Resource Share Accepter - Resolver Rules Forward master.local
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_share_accepter" "resolver_foward_master_local" {
  share_arn = var.ram_invitation_arn_resolver_rule_forward_master_local
}

# ----------------------------------------------------------------------------------------------
# RAM Resource Share Accepter - Resolver Rules Forward master.aws
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_share_accepter" "resolver_foward_master_aws" {
  share_arn = var.ram_invitation_arn_resolver_rule_forward_master_aws
}

# ----------------------------------------------------------------------------------------------
# RAM Resource Share Accepter - Resolver Rules System
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_share_accepter" "resolver_system" {
  share_arn = var.ram_invitation_arn_resolver_rule_system
}

# ----------------------------------------------------------------------------------------------
# RAM Resource Share Accepter - Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_share_accepter" "tgw" {
  share_arn = var.ram_invitation_arn_transit_gateway
}
