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
