module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "nfw-alb"

  load_balancer_type = "application"

  vpc_id          = var.vpc_id
  subnets         = var.public_subnets
  security_groups = [module.alb_sg.security_group_id]

  target_groups = [
    {
      name             = "nfw-tg"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = {
        instance1 = {
          target_id = module.ec2_instance1.id
          port      = 80
        }
        instance2 = {
          target_id = module.ec2_instance2.id
          port      = 80
        }
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
}
