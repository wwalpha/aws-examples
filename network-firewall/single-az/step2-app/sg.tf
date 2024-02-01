module "app_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name                = "app_sg"
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
  egress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
