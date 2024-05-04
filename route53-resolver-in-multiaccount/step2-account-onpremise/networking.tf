# ----------------------------------------------------------------------------------------------
# RAM Resource Share Accepter - Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_share_accepter" "tgw" {
  share_arn = var.ram_resource_share_arn_tgw
}

# ----------------------------------------------------------------------------------------------
# Networking - Onpremise
# ----------------------------------------------------------------------------------------------
module "networking" {
  depends_on                 = [aws_ram_resource_share_accepter.tgw]
  source                     = "../commons-networking"
  prefix                     = "${var.prefix}-onpremise"
  vpc_cidr_block             = var.vpc_cidr_block
  subnets_cidr_block_public  = var.subnets_cidr_block_public
  subnets_cidr_block_private = var.subnets_cidr_block_private
  availability_zones         = var.availability_zones
  transit_gateway_id         = var.transit_gateway_id
}
