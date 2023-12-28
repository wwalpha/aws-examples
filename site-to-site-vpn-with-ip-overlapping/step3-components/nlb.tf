# ----------------------------------------------------------------------------------------------
# Network Load Balancer for Relay EU
# ----------------------------------------------------------------------------------------------
resource "aws_lb" "relay_eu" {
  name               = "${var.prefix}-nlb-relay-eu"
  internal           = true
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id            = var.subnet_id_aws_relay_eu
    private_ipv4_address = "10.0.0.10"
  }
}

# ----------------------------------------------------------------------------------------------
# Network Load Balancer Target Group for Relay EU
# ----------------------------------------------------------------------------------------------
resource "aws_lb_target_group" "relay_eu" {
  name        = "${var.prefix}-tg-RelayEU"
  port        = 80
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.vpc_id_aws_relay_eu

  health_check {
    protocol            = "HTTP"
    path                = "/"
    matcher             = 200
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
}

# ----------------------------------------------------------------------------------------------
# Network Load Balancer Target Group Register Instance for Relay EU
# ----------------------------------------------------------------------------------------------
resource "aws_lb_target_group_attachment" "relay_eu" {
  target_group_arn  = aws_lb_target_group.relay_eu.arn
  target_id         = module.proxy_for_relay_jp.private_ip
  port              = 80
  availability_zone = "all"
}

# ----------------------------------------------------------------------------------------------
# Network Load Balancer Listener for Relay EU
# ----------------------------------------------------------------------------------------------
resource "aws_lb_listener" "relay_eu" {
  load_balancer_arn = aws_lb.relay_eu.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.relay_eu.arn
  }
}

# ----------------------------------------------------------------------------------------------
# Network Load Balancer for Relay US
# ----------------------------------------------------------------------------------------------
resource "aws_lb" "relay_us" {
  name               = "${var.prefix}-nlb-relay-us"
  internal           = true
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id            = var.subnet_id_aws_relay_us
    private_ipv4_address = "10.1.0.10"
  }
}

# ----------------------------------------------------------------------------------------------
# Network Load Balancer Target Group for Relay US
# ----------------------------------------------------------------------------------------------
resource "aws_lb_target_group" "relay_us" {
  name        = "${var.prefix}-tg-RelayUS"
  port        = 80
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.vpc_id_aws_relay_us

  health_check {
    protocol            = "HTTP"
    path                = "/"
    matcher             = 200
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
}

# ----------------------------------------------------------------------------------------------
# Network Load Balancer Target Group Register Instance for Relay US
# ----------------------------------------------------------------------------------------------
resource "aws_lb_target_group_attachment" "relay_us" {
  target_group_arn  = aws_lb_target_group.relay_us.arn
  target_id         = module.proxy_for_relay_jp.private_ip
  port              = 80
  availability_zone = "all"
}

# ----------------------------------------------------------------------------------------------
# Network Load Balancer Listener for Relay US
# ----------------------------------------------------------------------------------------------
resource "aws_lb_listener" "relay_us" {
  load_balancer_arn = aws_lb.relay_us.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.relay_us.arn
  }
}

# ----------------------------------------------------------------------------------------------
# Network Load Balancer for Relay JP
# ----------------------------------------------------------------------------------------------
resource "aws_lb" "relay_jp" {
  name               = "${var.prefix}-nlb-relay-jp"
  internal           = true
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id            = var.subnet_id_aws_relay_jp
    private_ipv4_address = "10.2.0.10"
  }
}

# ----------------------------------------------------------------------------------------------
# Network Load Balancer Target Group for Relay JP
# ----------------------------------------------------------------------------------------------
resource "aws_lb_target_group" "relay_jp" {
  name        = "${var.prefix}-tg-RelayJP"
  port        = 80
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.vpc_id_aws_relay_jp

  health_check {
    protocol            = "HTTP"
    path                = "/"
    matcher             = 200
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
}

# ----------------------------------------------------------------------------------------------
# Network Load Balancer Target Group Register Instance for Relay JP
# ----------------------------------------------------------------------------------------------
resource "aws_lb_target_group_attachment" "relay_jp" {
  target_group_arn = aws_lb_target_group.relay_jp.arn
  target_id        = module.proxy_for_relay_jp.private_ip
  port             = 80
}

# ----------------------------------------------------------------------------------------------
# Network Load Balancer Listener for Relay JP
# ----------------------------------------------------------------------------------------------
resource "aws_lb_listener" "relay_jp" {
  load_balancer_arn = aws_lb.relay_jp.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.relay_jp.arn
  }
}
