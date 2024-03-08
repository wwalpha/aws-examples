# ----------------------------------------------------------------------------------------------
# AWS EC2 Managed Prefix List - Egress VPC
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_managed_prefix_list" "egress" {
  name           = "Egress VPC CIDRs"
  address_family = "IPv4"
  max_entries    = 5

  entry {
    cidr        = local.vpc_cidr_block_egress
    description = "Primary"
  }

  tags = {
    Name = "${var.prefix}-egress-vpc"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS EC2 Managed Prefix List - Ingress VPC
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_managed_prefix_list" "ingress" {
  name           = "Ingress VPC CIDRs"
  address_family = "IPv4"
  max_entries    = 5

  entry {
    cidr = local.vpc_cidr_block_ingress
  }

  tags = {
    Name = "${var.prefix}-ingress-vpc"
  }
}
