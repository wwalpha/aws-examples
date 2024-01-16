# ----------------------------------------------------------------------------------------------
# ECS Task Security Group
# ----------------------------------------------------------------------------------------------
module "ocpp_gw_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_ocpp_gw_sg"
  vpc_id = var.vpc_id
  ingress_with_cidr_blocks = [
    {
      rule        = "all-icmp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "all-all"
      cidr_blocks = var.vpc_cidr_block
    }
  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
  }]
}
