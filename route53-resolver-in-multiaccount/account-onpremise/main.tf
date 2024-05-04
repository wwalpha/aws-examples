# ----------------------------------------------------------------------------------------------
# Networking - Onpremise
# ----------------------------------------------------------------------------------------------
module "networking" {
  source                     = "../commons-networking"
  prefix                     = "${var.prefix}-onpremise"
  vpc_cidr_block             = var.vpc_cidr_block
  subnets_cidr_block_public  = var.subnets_cidr_block_public
  subnets_cidr_block_private = var.subnets_cidr_block_private
  availability_zones         = var.availability_zones
  transit_gateway_id         = var.transit_gateway_id
}
