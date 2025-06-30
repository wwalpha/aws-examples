# ----------------------------------------------------------------------------------------------
# Application Load Balancer
# ----------------------------------------------------------------------------------------------
resource "aws_lb" "proxy" {
  name                   = "feature-honbu-${var.env_name}-proxy"
  desync_mitigation_mode = "defensive"
  enable_waf_fail_open   = false
  internal               = false
  load_balancer_type     = "application"
  security_groups        = [aws_security_group.elb_proxy.id, var.sg_client_vpn]
  subnets                = var.public_subnets
  idle_timeout           = 300
}

# ----------------------------------------------------------------------------------------------
# Application Load Balancer Target Group - Resource
# ----------------------------------------------------------------------------------------------
resource "aws_lb_target_group" "proxy" {
  name                               = "feature-honbu-${var.env_name}-proxy"
  port                               = 80
  protocol                           = "HTTP"
  target_type                        = "instance"
  vpc_id                             = var.vpc_id
  lambda_multi_value_headers_enabled = false
  proxy_protocol_v2                  = false

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags
    ]
  }
}

# ----------------------------------------------------------------------------------------------
# Application Load Balancer Target Group
# ----------------------------------------------------------------------------------------------
resource "aws_lb_listener" "proxy" {
  depends_on = [aws_lb_target_group.proxy]

  load_balancer_arn = aws_lb.proxy.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not authorized CloudFront access"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "proxy" {
  listener_arn = aws_lb_listener.proxy.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.proxy.arn
  }

  condition {
    http_header {
      http_header_name = "x-shared-key"
      values           = [var.shared_key]
    }
  }

  # condition {
  #   http_header {
  #     http_header_name = "x-access-control-key"
  #     values           = [var.shared_key]
  #   }
  # }
  # condition {
  #   http_header {
  #     http_header_name = "x-cfn-id"
  #     values           = [aws_cloudfront_distribution.this.id]
  #   }
  # }
}

# ----------------------------------------------------------------------------------------------
# Application Load Balancer
# ----------------------------------------------------------------------------------------------
resource "aws_lb" "app" {
  name                   = "feature-honbu-${var.env_name}-app"
  desync_mitigation_mode = "defensive"
  enable_waf_fail_open   = false
  internal               = true
  load_balancer_type     = "application"
  security_groups        = [aws_security_group.elb_app.id, var.sg_client_vpn]
  subnets                = var.private_subnets
  tags                   = {}
  idle_timeout           = 300
}

# ----------------------------------------------------------------------------------------------
# Application Load Balancer Target Group - Resource
# ----------------------------------------------------------------------------------------------
resource "aws_lb_target_group" "app" {
  name                               = "feature-honbu-${var.env_name}-app"
  port                               = 80
  protocol                           = "HTTP"
  target_type                        = "instance"
  vpc_id                             = var.vpc_id
  lambda_multi_value_headers_enabled = false
  proxy_protocol_v2                  = false
  tags                               = {}

  lifecycle {
    create_before_destroy = true
  }
}

# ----------------------------------------------------------------------------------------------
# Application Load Balancer Target Group
# ----------------------------------------------------------------------------------------------
resource "aws_lb_listener" "app" {
  depends_on = [aws_lb_target_group.app, aws_lb.app]

  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
