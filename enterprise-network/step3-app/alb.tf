# ----------------------------------------------------------------------------------------------
# Application Load Balancer - Nginx
# ----------------------------------------------------------------------------------------------
resource "aws_lb" "nginx" {
  name               = "${var.prefix}-lb-nginx"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.nginx_sg.security_group_id]
  subnets            = var.vpc_subnets_ingress_public
}

# ----------------------------------------------------------------------------------------------
# Application Load Balancer Target Group - Nginx
# ----------------------------------------------------------------------------------------------
resource "aws_lb_target_group" "nginx" {
  name        = "${var.prefix}-tg-nginx"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id_ingress
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
  target_group_arn  = aws_lb_target_group.nginx.arn
  target_id         = module.nginx.private_ip
  port              = 80
  availability_zone = "all"
}


# ----------------------------------------------------------------------------------------------
# Application Load Balancer - Apache
# ----------------------------------------------------------------------------------------------
resource "aws_lb" "apache" {
  name               = "${var.prefix}-lb-apache"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.apache_sg.security_group_id]
  subnets            = var.vpc_subnets_workload_web_public
}

# ----------------------------------------------------------------------------------------------
# Application Load Balancer Target Group - Apache
# ----------------------------------------------------------------------------------------------
resource "aws_lb_target_group" "apache" {
  name        = "${var.prefix}-tg-apache"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id_workload_web
}

# ----------------------------------------------------------------------------------------------
# Application Load Balancer Listener - Apache
# ----------------------------------------------------------------------------------------------
resource "aws_lb_listener" "apache" {
  load_balancer_arn = aws_lb.apache.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apache.arn
  }
}

# ----------------------------------------------------------------------------------------------
# Application Load Balancer Target Group Attachment - Apache
# ----------------------------------------------------------------------------------------------
resource "aws_lb_target_group_attachment" "apache" {
  target_group_arn = aws_lb_target_group.apache.arn
  target_id        = module.apache.private_ip
  port             = 80
}
