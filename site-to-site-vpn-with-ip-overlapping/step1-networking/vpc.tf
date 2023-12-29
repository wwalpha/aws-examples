# ----------------------------------------------------------------------------------------------
# OnPremise EU VPC
# ----------------------------------------------------------------------------------------------
module "onpremise_eu_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.prefix}-OnPremiseEU"
  cidr                 = "192.168.0.0/16"
  azs                  = local.availability_zones
  public_subnets       = ["192.168.0.0/24", "192.168.1.0/24"]
  enable_dns_hostnames = true
  enable_nat_gateway   = false
}

# ----------------------------------------------------------------------------------------------
# OnPremise US VPC
# ----------------------------------------------------------------------------------------------
module "onpremise_us_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.prefix}-OnPremiseUS"
  cidr                 = "192.168.0.0/16"
  azs                  = local.availability_zones
  public_subnets       = ["192.168.0.0/24", "192.168.1.0/24"]
  enable_dns_hostnames = true
  enable_nat_gateway   = false
}

# ----------------------------------------------------------------------------------------------
# OnPremise JP VPC
# ----------------------------------------------------------------------------------------------
module "onpremise_jp_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.prefix}-OnPremiseJP"
  cidr                 = "172.16.0.0/16"
  azs                  = local.availability_zones
  public_subnets       = ["172.16.0.0/24", "172.16.1.0/24"]
  enable_dns_hostnames = true
  enable_nat_gateway   = false
}

# ----------------------------------------------------------------------------------------------
# AWS Relay VPC for OnPremise EU
# ----------------------------------------------------------------------------------------------
module "relay_vpc_for_eu" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.prefix}-RelayEU"
  cidr                 = "10.0.0.0/16"
  azs                  = local.availability_zones
  public_subnets       = ["10.0.0.0/24", "10.0.1.0/24"]
  enable_dns_hostnames = true
  enable_nat_gateway   = false
}

# ----------------------------------------------------------------------------------------------
# AWS Relay VPC for OnPremise US
# ----------------------------------------------------------------------------------------------
module "relay_vpc_for_us" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.prefix}-RelayUS"
  cidr                 = "10.1.0.0/16"
  azs                  = local.availability_zones
  public_subnets       = ["10.1.0.0/24", "10.1.1.0/24"]
  enable_dns_hostnames = true
  enable_nat_gateway   = false
}

# ----------------------------------------------------------------------------------------------
# AWS Relay VPC for OnPremise JP
# ----------------------------------------------------------------------------------------------
module "relay_vpc_for_jp" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.prefix}-RelayJP"
  cidr                 = "10.2.0.0/16"
  azs                  = local.availability_zones
  public_subnets       = ["10.2.0.0/24", "10.2.1.0/24"]
  enable_dns_hostnames = true
  enable_nat_gateway   = false
}

# ----------------------------------------------------------------------------------------------
# AWS Application VPC
# ----------------------------------------------------------------------------------------------
module "aws_app_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.prefix}-AWS-App"
  cidr                 = "10.10.0.0/16"
  azs                  = local.availability_zones
  public_subnets       = ["10.10.0.0/24", "10.10.1.0/24"]
  enable_dns_hostnames = true
  enable_nat_gateway   = false
}

# ----------------------------------------------------------------------------------------------
# Relay EU Peering with Relay JP
# ----------------------------------------------------------------------------------------------
# resource "aws_vpc_peering_connection" "relay_eu_peering_relay_jp" {
#   peer_owner_id = local.aws_account_id
#   peer_vpc_id   = module.relay_vpc_for_jp.vpc_id
#   vpc_id        = module.relay_vpc_for_eu.vpc_id
#   auto_accept   = true

#   accepter {
#     allow_remote_vpc_dns_resolution = true
#   }

#   requester {
#     allow_remote_vpc_dns_resolution = true
#   }

#   tags = {
#     Name = "${var.prefix}-RelayEU-Peering-RelayJP"
#   }
# }

# ----------------------------------------------------------------------------------------------
# Relay US Peering with Relay JP
# ----------------------------------------------------------------------------------------------
# resource "aws_vpc_peering_connection" "relay_us_peering_relay_jp" {
#   peer_owner_id = local.aws_account_id
#   peer_vpc_id   = module.relay_vpc_for_jp.vpc_id
#   vpc_id        = module.relay_vpc_for_us.vpc_id
#   auto_accept   = true

#   accepter {
#     allow_remote_vpc_dns_resolution = true
#   }

#   requester {
#     allow_remote_vpc_dns_resolution = true
#   }

#   tags = {
#     Name = "${var.prefix}-RelayUS-Peering-RelayJP"
#   }
# }
