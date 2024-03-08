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

# module "alb_sg" {
#   source = "terraform-aws-modules/security-group/aws"

#   name   = "alb_sg"
#   vpc_id = var.vpc_id
#   ingress_with_cidr_blocks = [
#     {
#       rule        = "http-80-tcp"
#       cidr_blocks = "10.10.0.0/16"
#     }
#   ]
#   egress_with_source_security_group_id = [{
#     rule                     = "http-80-tcp"
#     source_security_group_id = module.app_sg.security_group_id
#   }]
# }
