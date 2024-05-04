# ----------------------------------------------------------------------------------------------
# Networking Central DNS
# ----------------------------------------------------------------------------------------------
module "networking_central_dns" {
  source                     = "../commons-networking"
  prefix                     = "${var.prefix}-central-dns"
  vpc_cidr_block             = var.vpc_cidr_block
  subnets_cidr_block_public  = var.subnets_cidr_block_public
  subnets_cidr_block_private = var.subnets_cidr_block_private
  availability_zones         = var.availability_zones
  transit_gateway_id         = var.transit_gateway_id
}
