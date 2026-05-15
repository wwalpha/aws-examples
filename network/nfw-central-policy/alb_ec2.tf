# Amazon Linux 2023 image selection
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - ALB
# ----------------------------------------------------------------------------------------------
resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Security group for the public ALB"
  vpc_id      = aws_vpc.workload.id

  tags = {
    Name = "${var.name_prefix}-alb-sg"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - EC2
# ----------------------------------------------------------------------------------------------
resource "aws_security_group" "ec2" {
  name        = "${var.name_prefix}-ec2-sg"
  description = "Security group for the private NGINX instance"
  vpc_id      = aws_vpc.workload.id

  tags = {
    Name = "${var.name_prefix}-ec2-sg"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Security Group Ingress Rule - ALB HTTP In
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_security_group_ingress_rule" "alb_http_in" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  description = "Allow HTTP from the internet"
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Security Group Egress Rule - ALB HTTP To EC2
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_security_group_egress_rule" "alb_http_to_ec2" {
  security_group_id            = aws_security_group.alb.id
  referenced_security_group_id = aws_security_group.ec2.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80

  description = "Allow HTTP from the ALB to the EC2 target"
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Security Group Ingress Rule - EC2 HTTP From ALB
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_security_group_ingress_rule" "ec2_http_from_alb" {
  security_group_id            = aws_security_group.ec2.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80

  description = "Allow HTTP from the ALB security group"
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Security Group Egress Rule - EC2 HTTP Out
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_security_group_egress_rule" "ec2_http_out" {
  security_group_id = aws_security_group.ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  description = "Allow outbound HTTP to the internet via egress VPC"
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Security Group Egress Rule - EC2 HTTPS Out
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_security_group_egress_rule" "ec2_https_out" {
  security_group_id = aws_security_group.ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443

  description = "Allow outbound HTTPS to the internet via egress VPC"
}

# ----------------------------------------------------------------------------------------------
# AWS Load Balancer - NGINX
# ----------------------------------------------------------------------------------------------
resource "aws_lb" "nginx" {
  name               = "${var.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets = [
    aws_subnet.workload["alb_public_a"].id,
    aws_subnet.workload["alb_public_c"].id,
  ]

  tags = {
    Name = "${var.name_prefix}-alb"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Load Balancer Target Group - NGINX
# ----------------------------------------------------------------------------------------------
resource "aws_lb_target_group" "nginx" {
  name        = "${var.name_prefix}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.workload.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200-399"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.name_prefix}-tg"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Load Balancer Listener - HTTP
# ----------------------------------------------------------------------------------------------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Instance - NGINX
# ----------------------------------------------------------------------------------------------
resource "aws_instance" "nginx" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.workload["ec2_private_a"].id
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  associate_public_ip_address = false
  user_data                   = local.nginx_user_data
  user_data_replace_on_change = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  depends_on = [time_sleep.egress_path_ready]

  tags = {
    Name = "${var.name_prefix}-nginx"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Load Balancer Target Group Attachment - NGINX
# ----------------------------------------------------------------------------------------------
resource "aws_lb_target_group_attachment" "nginx" {
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = aws_instance.nginx.id
  port             = 80
}
