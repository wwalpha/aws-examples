# ----------------------------------------------------------------------------------------------
# OnPremise A VPC
# ----------------------------------------------------------------------------------------------
module "onpremise_a_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.prefix}-OnPremiseA"
  cidr                 = "192.168.0.0/16"
  azs                  = local.availability_zones
  public_subnets       = ["192.168.0.0/24", "192.168.1.0/24"]
  enable_dns_hostnames = true
  enable_nat_gateway   = false
}

# ----------------------------------------------------------------------------------------------
# OnPremise B VPC
# ----------------------------------------------------------------------------------------------
module "onpremise_b_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.prefix}-OnPremiseB"
  cidr                 = "192.168.0.0/16"
  azs                  = local.availability_zones
  public_subnets       = ["192.168.0.0/24", "192.168.1.0/24"]
  enable_dns_hostnames = true
  enable_nat_gateway   = false
}

# ----------------------------------------------------------------------------------------------
# AWS Relay VPC for OnPremise A
# ----------------------------------------------------------------------------------------------
module "aws_relay_vpc_for_a" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.prefix}-AWS-Relay-OnPremiseA"
  cidr                 = "10.0.0.0/16"
  azs                  = local.availability_zones
  public_subnets       = ["10.0.0.0/24", "10.0.1.0/24"]
  enable_dns_hostnames = true
  enable_nat_gateway   = false
}

# ----------------------------------------------------------------------------------------------
# AWS Relay VPC for OnPremise B
# ----------------------------------------------------------------------------------------------
module "aws_relay_vpc_for_b" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.prefix}-AWS-Relay-OnPremiseB"
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
