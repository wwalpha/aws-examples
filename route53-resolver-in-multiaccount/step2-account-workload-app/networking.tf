# ----------------------------------------------------------------------------------------------
# RAM Resource Share Accepter - Resolver Rules Forward Onpremise(master.local)
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_share_accepter" "resolver_forward_onpremise" {
  share_arn = var.ram_share_arn_resolver_forward_onpremise
}

# ----------------------------------------------------------------------------------------------
# RAM Resource Share Accepter - Resolver Rules Forward Cloud(master.aws)
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_share_accepter" "resolver_forward_cloud" {
  share_arn = var.ram_share_arn_resolver_forward_cloud
}

# ----------------------------------------------------------------------------------------------
# RAM Resource Share Accepter - Resolver Rules System
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_share_accepter" "resolver_system" {
  share_arn = var.ram_share_arn_resolver_system
}

# ----------------------------------------------------------------------------------------------
# RAM Resource Share Accepter - Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_share_accepter" "tgw" {
  share_arn = var.ram_share_arn_transit_gateway
}
