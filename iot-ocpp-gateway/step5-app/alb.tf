# ----------------------------------------------------------------------------------------------
# AWS Network Load Balancer - Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_lb" "this" {
  name                             = "${var.prefix}-Gateway"
  internal                         = false
  ip_address_type                  = "ipv4"
  load_balancer_type               = "network"
  dns_record_client_routing_policy = "any_availability_zone"
  enable_cross_zone_load_balancing = false
  enable_deletion_protection       = false
  subnets                          = var.vpc_public_subnet_ids
}

# ----------------------------------------------------------------------------------------------
# AWS Network Load Balancer Target Group - Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_lb_target_group" "this" {
  name                              = "${var.prefix}-GatewayTG"
  ip_address_type                   = "ipv4"
  target_type                       = "ip"
  connection_termination            = false
  deregistration_delay              = "10"
  load_balancing_cross_zone_enabled = "use_load_balancer_configuration"
  port                              = 80
  preserve_client_ip                = "false"
  protocol                          = "TCP"
  vpc_id                            = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 10
    matcher             = null
    path                = null
    port                = "traffic-port"
    protocol            = "TCP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}


# ----------------------------------------------------------------------------------------------
# AWS Network Load Balancer Listener - Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.this.arn
    type             = "forward"
  }
}
