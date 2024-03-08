module "workload_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_workload_sg"
  vpc_id = var.vpc_id_workload
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
    }
  ]
}

module "ingress_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_ingress_sg"
  vpc_id = var.vpc_id_ingress
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
    }
  ]
}

