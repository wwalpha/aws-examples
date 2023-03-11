module "app_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "app_sg"
  vpc_id = var.vpc_id
  ingress_with_source_security_group_id = [
    {
      rule                     = "http-8080-tcp"
      source_security_group_id = module.alb_sg.security_group_id
    }
  ]
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

module "alb_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "alb_sg"
  vpc_id = var.vpc_id
  ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_source_security_group_id = [
    {
      rule                     = "http-8080-tcp"
      source_security_group_id = module.app_sg.security_group_id
    }
  ]
}
