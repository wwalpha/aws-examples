# ----------------------------------------------------------------------------------------------
# AWS EC2 Instance - DNS
# ----------------------------------------------------------------------------------------------
module "onpremise_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_onpremise_sg"
  vpc_id = var.vpc_id
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
