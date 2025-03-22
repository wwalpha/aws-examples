# ----------------------------------------------------------------------------------------------
# VPC
# ----------------------------------------------------------------------------------------------
module "vpc_clientvpn" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.prefix}-clientvpn"
  cidr                 = local.vpc_cidr_block_vpn
  azs                  = local.availability_zones
  private_subnets      = local.private_subnets_cidr_block_vpn
  enable_nat_gateway   = false
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# ----------------------------------------------------------------------------------------------
# VPC
# ----------------------------------------------------------------------------------------------
module "vpc_01" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.prefix}-vpc01"
  cidr                 = local.vpc_cidr_block_01
  azs                  = local.availability_zones
  private_subnets      = local.private_subnets_cidr_block_01
  enable_nat_gateway   = false
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# ----------------------------------------------------------------------------------------------
# VPC
# ----------------------------------------------------------------------------------------------
module "vpc_02" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.prefix}-vpc02"
  cidr                 = local.vpc_cidr_block_02
  azs                  = local.availability_zones
  private_subnets      = local.private_subnets_cidr_block_02
  enable_nat_gateway   = false
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# ----------------------------------------------------------------------------------------------
# VPC Peering Connection - VPN to VPC01
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_peering_connection" "vpn_peering_vpc01" {
  peer_owner_id = "016725430159"
  peer_vpc_id   = module.vpc_clientvpn.vpc_id
  vpc_id        = module.vpc_01.vpc_id
  auto_accept   = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

# ----------------------------------------------------------------------------------------------
# VPC Peering Connection - VPN to VPC02
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_peering_connection" "vpn_peering_vpc02" {
  peer_owner_id = "016725430159"
  peer_vpc_id   = module.vpc_clientvpn.vpc_id
  vpc_id        = module.vpc_02.vpc_id
  auto_accept   = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route - VPN to VPC01
# ----------------------------------------------------------------------------------------------
resource "aws_route" "vpn_to_vpc01" {
  count                     = length(module.vpc_clientvpn.private_route_table_ids)
  route_table_id            = module.vpc_clientvpn.private_route_table_ids[count.index]
  destination_cidr_block    = module.vpc_01.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpn_peering_vpc01.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route - VPN to VPC02
# ----------------------------------------------------------------------------------------------
resource "aws_route" "vpn_to_vpc02" {
  count                     = length(module.vpc_clientvpn.private_route_table_ids)
  route_table_id            = module.vpc_clientvpn.private_route_table_ids[count.index]
  destination_cidr_block    = module.vpc_02.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpn_peering_vpc02.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route - VPC01 to VPN
# ----------------------------------------------------------------------------------------------
resource "aws_route" "vpc01_to_vpn" {
  count                     = length(module.vpc_01.private_route_table_ids)
  route_table_id            = module.vpc_01.private_route_table_ids[count.index]
  destination_cidr_block    = module.vpc_clientvpn.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpn_peering_vpc01.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route - VPC02 to VPN
# ----------------------------------------------------------------------------------------------
resource "aws_route" "vpc02_to_vpn" {
  count                     = length(module.vpc_02.private_route_table_ids)
  route_table_id            = module.vpc_02.private_route_table_ids[count.index]
  destination_cidr_block    = module.vpc_clientvpn.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpn_peering_vpc02.id
}
