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

# # ----------------------------------------------------------------------------------------------
# # Company B Router Security Group
# # ----------------------------------------------------------------------------------------------
# module "router_sg_company_b" {
#   source = "terraform-aws-modules/security-group/aws"

#   name   = "${var.prefix}_router_sg"
#   vpc_id = var.vpc_id_company_b
#   ingress_with_cidr_blocks = [
#     {
#       rule        = "rdp-tcp"
#       cidr_blocks = "0.0.0.0/0"
#     },
#     {
#       rule        = "all-icmp"
#       cidr_blocks = "0.0.0.0/0"
#     },
#     {
#       rule        = "all-all"
#       cidr_blocks = "0.0.0.0/0"
#     }
#   ]
#   egress_with_cidr_blocks = [
#     {
#       rule        = "all-all"
#       cidr_blocks = "0.0.0.0/0"
#   }]
# }

# # ----------------------------------------------------------------------------------------------
# # Company B Server Security Group
# # ----------------------------------------------------------------------------------------------
# module "server_sg_company_b" {
#   source = "terraform-aws-modules/security-group/aws"

#   name   = "${var.prefix}_server_sg"
#   vpc_id = var.vpc_id_company_b
#   ingress_with_cidr_blocks = [
#     {
#       rule        = "all-icmp"
#       cidr_blocks = "0.0.0.0/0"
#     },
#     {
#       rule        = "all-all"
#       cidr_blocks = "0.0.0.0/0"
#     }
#   ]
#   egress_with_cidr_blocks = [
#     {
#       rule        = "all-all"
#       cidr_blocks = "0.0.0.0/0"
#   }]
# }

# ----------------------------------------------------------------------------------------------
# AWS NGINX Security Group
# ----------------------------------------------------------------------------------------------
module "aws_sg_nginx" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_nginx_sg"
  vpc_id = var.vpc_id_aws_site
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
