# ----------------------------------------------------------------------------------------------
# Application Load Balancer - Nginx
# ----------------------------------------------------------------------------------------------
resource "aws_lb" "nginx" {
  name               = "${var.prefix}-lb-nginx"
  internal           = var.alb_internal
  load_balancer_type = "application"
  security_groups    = [module.sg.security_group_id]
  subnets            = var.vpc_public_subnet_ids

  lifecycle {
    ignore_changes = [access_logs]
  }
}

# ----------------------------------------------------------------------------------------------
# Application Load Balancer Target Group - Nginx
# ----------------------------------------------------------------------------------------------
resource "aws_lb_target_group" "nginx" {
  name     = "${var.prefix}-tg-nginx"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# ----------------------------------------------------------------------------------------------
# Application Load Balancer Listener - Nginx
# ----------------------------------------------------------------------------------------------
resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }
}

# ----------------------------------------------------------------------------------------------
# Application Load Balancer Target Group Attachment - Nginx
# ----------------------------------------------------------------------------------------------
resource "aws_lb_target_group_attachment" "nginx" {
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = module.nginx.id
  port             = 80
}
