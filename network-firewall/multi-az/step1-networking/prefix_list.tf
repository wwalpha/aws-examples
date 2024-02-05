# ----------------------------------------------------------------------------------------------
# AWS EC2 Managed Prefix List - Egress VPC
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_managed_prefix_list" "egress" {
  name           = "Egress VPC CIDRs"
  address_family = "IPv4"
  max_entries    = 5

  entry {
    cidr        = local.vpc_cidr_block_dmz
    description = "Primary"
  }

  tags = {
    Name = "${var.prefix}-egress-vpc"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS EC2 Managed Prefix List - Egress VPC
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_managed_prefix_list" "aws_cidr_block" {
  name           = "AWS Cloud CIDRs"
  address_family = "IPv4"
  max_entries    = 5

  entry {
    cidr        = local.cidr_block_aws_cloud
    description = "Primary"
  }

  tags = {
    Name = "${var.prefix}-aws-cloud-cidrs"
  }
}
