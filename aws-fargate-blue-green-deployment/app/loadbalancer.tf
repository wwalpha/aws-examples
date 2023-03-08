# ----------------------------------------------------------------------------------------------
# Application load balancer
# ----------------------------------------------------------------------------------------------
resource "aws_lb" "this" {
  name                       = "${var.prefix}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [module.alb_sg.security_group_id]
  subnets                    = var.public_subnet_ids
  enable_deletion_protection = false
}

# ----------------------------------------------------------------------------------------------
# Load Balancer Target Group IP Address - Blue
# ----------------------------------------------------------------------------------------------
resource "aws_lb_target_group" "blue" {
  name        = "${var.prefix}-blue-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/health"
  }
}

# ----------------------------------------------------------------------------------------------
# Load Balancer Target Group IP Address - Green
# ----------------------------------------------------------------------------------------------
resource "aws_lb_target_group" "green" {
  name        = "${var.prefix}-green-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/health"
  }
}

# ----------------------------------------------------------------------------------------------
# Load Balancer Listener - Production
# ----------------------------------------------------------------------------------------------
resource "aws_lb_listener" "production" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}

# ----------------------------------------------------------------------------------------------
# Load Balancer Listener - Test
# ----------------------------------------------------------------------------------------------
resource "aws_lb_listener" "test" {
  load_balancer_arn = aws_lb.this.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }
}
