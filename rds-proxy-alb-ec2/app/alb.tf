module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name               = "${var.prefix}-alb"
  load_balancer_type = "application"
  vpc_id             = var.vpc_id
  subnets            = var.public_subnets
  security_groups    = [module.alb_sg.security_group_id]

  target_groups = [
    {
      name             = "${var.prefix}-tg"
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "instance"
      targets = {
        instance1 = {
          target_id = module.ec2_instance.id
          port      = 8080
        }
      }
      health_check = {
        path = "/v1/health"
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
