# ----------------------------------------------------------------------------------------------
# Company A Router Security Group
# ----------------------------------------------------------------------------------------------
module "router_sg_company_a" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_router_sg"
  vpc_id = var.vpc_id_company_a
  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "all-icmp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
  }]
}

# ----------------------------------------------------------------------------------------------
# Company A Server Security Group
# ----------------------------------------------------------------------------------------------
module "server_sg_company_a" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_server_sg"
  vpc_id = var.vpc_id_company_a
  ingress_with_cidr_blocks = [
    {
      rule        = "all-icmp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
  }]
}

# ----------------------------------------------------------------------------------------------
# Company A Router Security Group
# ----------------------------------------------------------------------------------------------
module "router_sg_company_b" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_router_sg"
  vpc_id = var.vpc_id_company_b
  ingress_with_cidr_blocks = [
    {
      rule        = "rdp-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "all-icmp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
  }]
}
