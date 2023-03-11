module "app_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "app_sg"
  vpc_id = var.vpc_id
  egress_with_source_security_group_id = [
    {
      rule                     = "postgresql-tcp"
      source_security_group_id = var.database_proxy_sg_id
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
