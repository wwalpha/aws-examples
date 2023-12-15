# ----------------------------------------------------------------------------------------------
# Company A VPC
# ----------------------------------------------------------------------------------------------
module "company_a" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.prefix}-CompanyA"
  cidr                 = "192.168.0.0/16"
  azs                  = local.availability_zones
  public_subnets       = ["192.168.0.0/24", "192.168.1.0/24"]
  enable_dns_hostnames = true
  enable_nat_gateway   = false
}

# ----------------------------------------------------------------------------------------------
# Company B VPC
# ----------------------------------------------------------------------------------------------
# module "company_b" {
#   source = "terraform-aws-modules/vpc/aws"

#   name                 = "${var.prefix}-CompanyB"
#   cidr                 = "172.16.0.0/16"
#   azs                  = local.availability_zones
#   public_subnets       = ["172.16.0.0/24", "172.16.1.0/24"]
#   enable_dns_hostnames = true
#   enable_nat_gateway   = false
# }

# ----------------------------------------------------------------------------------------------
# AWS VPC
# ----------------------------------------------------------------------------------------------
module "aws_site" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.prefix}-AWS"
  cidr                 = "10.0.0.0/16"
  azs                  = local.availability_zones
  public_subnets       = ["10.0.0.0/24", "10.0.1.0/24"]
  enable_dns_hostnames = true
  enable_nat_gateway   = false
}
