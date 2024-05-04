# ----------------------------------------------------------------------------------------------
# Networking
# ----------------------------------------------------------------------------------------------
module "networking" {
  source                     = "../commons-networking"
  prefix                     = "${var.prefix}-workload-app2"
  vpc_cidr_block             = var.vpc_cidr_block
  subnets_cidr_block_public  = var.subnets_cidr_block_public
  subnets_cidr_block_private = var.subnets_cidr_block_private
  availability_zones         = var.availability_zones
  transit_gateway_id         = var.transit_gateway_id
}

# ----------------------------------------------------------------------------------------------
# Application
# ----------------------------------------------------------------------------------------------
module "application" {
  source                 = "./app"
  prefix                 = "${var.prefix}-workload-app2"
  vpc_id                 = module.networking.vpc_id
  vpc_public_subnet_ids  = module.networking.vpc_public_subnet_ids
  vpc_private_subnet_ids = module.networking.vpc_private_subnet_ids
}
