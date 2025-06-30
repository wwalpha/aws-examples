# ----------------------------------------------------------------------------------------------
# AWS Security Group - proxy
# ----------------------------------------------------------------------------------------------
resource "aws_security_group" "proxy" {
  name        = "honbu-${var.env_name}-proxy"
  description = "honbu-${var.env_name}-proxy"
  vpc_id      = var.vpc_id

  tags = {
    Name = "honbu-${var.env_name}-proxy"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - app
# ----------------------------------------------------------------------------------------------
resource "aws_security_group" "app" {
  name        = "honbu-${var.env_name}-app"
  description = "honbu-${var.env_name}-app"
  vpc_id      = var.vpc_id

  tags = {
    Name = "honbu-${var.env_name}-app"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - batch
# ----------------------------------------------------------------------------------------------
resource "aws_security_group" "batch" {
  name        = "honbu-${var.env_name}-batch"
  description = "honbu-${var.env_name}-batch"
  vpc_id      = var.vpc_id

  tags = {
    Name = "honbu-${var.env_name}-batch"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - DB
# ----------------------------------------------------------------------------------------------
resource "aws_security_group" "db" {
  name        = "honbu-${var.env_name}-db"
  description = "honbu-${var.env_name}-db"
  vpc_id      = var.vpc_id

  tags = {
    Name = "honbu-${var.env_name}-db"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - ELB Proxy
# ----------------------------------------------------------------------------------------------
resource "aws_security_group" "elb_proxy" {
  name        = "honbu-${var.env_name}-alb-proxy"
  description = "honbu-${var.env_name}-alb-proxy"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "honbu-${var.env_name}-alb-proxy"
  }
}


# ----------------------------------------------------------------------------------------------
# AWS Security Group - ELB Application
# ----------------------------------------------------------------------------------------------
resource "aws_security_group" "elb_app" {
  name        = "honbu-${var.env_name}-alb-app"
  description = "honbu-${var.env_name}-alb-app"
  vpc_id      = var.vpc_id

  tags = {
    Name = "honbu-${var.env_name}-alb-app"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - ELB Proxy -> EC2 Proxy (Outbound)
# ----------------------------------------------------------------------------------------------
resource "aws_security_group_rule" "elb_to_proxy" {
  depends_on = [
    aws_security_group.proxy,
    aws_security_group.elb_proxy
  ]

  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.proxy.id
  security_group_id        = aws_security_group.elb_proxy.id
  description              = "Proxy"
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - EC2 Proxy <- ELB Proxy (Inbound)
# ----------------------------------------------------------------------------------------------
resource "aws_security_group_rule" "proxy_from_elb_proxy" {
  depends_on = [
    aws_security_group.proxy,
    aws_security_group.elb_proxy
  ]

  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.elb_proxy.id
  security_group_id        = aws_security_group.proxy.id
  description              = "ELB Proxy"
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - EC2 Proxy -> ELB Application (Outbound)
# ----------------------------------------------------------------------------------------------
resource "aws_security_group_rule" "proxy_to_elb_app" {
  depends_on = [
    aws_security_group.elb_app,
    aws_security_group.proxy
  ]

  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.elb_app.id
  security_group_id        = aws_security_group.proxy.id
  description              = "ELB Application"
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - ELB Application <- EC2 Proxy (Inbound)
# ----------------------------------------------------------------------------------------------
resource "aws_security_group_rule" "elb_app_from_proxy" {
  depends_on = [
    aws_security_group.proxy,
    aws_security_group.elb_app
  ]

  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.proxy.id
  security_group_id        = aws_security_group.elb_app.id
  description              = "Proxy"
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - ELB Application -> EC2 Application (Outbound)
# ----------------------------------------------------------------------------------------------
resource "aws_security_group_rule" "elb_app_to_app" {
  depends_on = [
    aws_security_group.app,
    aws_security_group.elb_app
  ]

  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app.id
  security_group_id        = aws_security_group.elb_app.id
  description              = "Application"
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - EC2 App <- ELB Proxy (Inbound)
# ----------------------------------------------------------------------------------------------
resource "aws_security_group_rule" "app_from_elb_app" {
  depends_on = [
    aws_security_group.elb_app,
    aws_security_group.app
  ]

  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.elb_app.id
  security_group_id        = aws_security_group.app.id
  description              = "ELB Application"
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - EC2 Application -> RDS (Outbound)
# ----------------------------------------------------------------------------------------------
resource "aws_security_group_rule" "app_to_db" {
  depends_on = [
    aws_security_group.db,
    aws_security_group.app
  ]

  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.db.id
  security_group_id        = aws_security_group.app.id
  description              = "DB"
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - EC2 Batch -> RDS (Outbound)
# ----------------------------------------------------------------------------------------------
resource "aws_security_group_rule" "batch_to_db" {
  depends_on = [
    aws_security_group.db,
    aws_security_group.batch
  ]

  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.db.id
  security_group_id        = aws_security_group.batch.id
  description              = "DB"
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - RDS <- EC2 Application (Inbound)
# ----------------------------------------------------------------------------------------------
resource "aws_security_group_rule" "db_from_app" {
  depends_on = [
    aws_security_group.app,
    aws_security_group.db
  ]

  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app.id
  security_group_id        = aws_security_group.db.id
  description              = "Application"
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - RDS <- EC2 Batch (Inbound)
# ----------------------------------------------------------------------------------------------
resource "aws_security_group_rule" "db_from_batch" {
  depends_on = [
    aws_security_group.batch,
    aws_security_group.db
  ]

  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.batch.id
  security_group_id        = aws_security_group.db.id
  description              = "Batch"
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - EC2 Batch -> AWS Endpoints (Outbound)
# ----------------------------------------------------------------------------------------------
resource "aws_security_group_rule" "batch_to_endpoints" {
  depends_on = [
    aws_security_group.batch
  ]

  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.sg_vpc_endpoint
  security_group_id        = aws_security_group.batch.id
  description              = "AWS Endpoint"
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - EC2 Application -> AWS Endpoints (Outbound)
# ----------------------------------------------------------------------------------------------
resource "aws_security_group_rule" "app_to_endpoints" {
  depends_on = [
    aws_security_group.app
  ]

  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.sg_vpc_endpoint
  security_group_id        = aws_security_group.app.id
  description              = "AWS Endpoint"
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - EC2 Proxy -> AWS Endpoints (Outbound)
# ----------------------------------------------------------------------------------------------
resource "aws_security_group_rule" "proxy_to_endpoints" {
  depends_on = [
    aws_security_group.proxy
  ]

  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.sg_vpc_endpoint
  security_group_id        = aws_security_group.proxy.id
  description              = "AWS Endpoint"
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - EC2 Batch (Inbound)
# ----------------------------------------------------------------------------------------------
resource "aws_security_group_rule" "batch_from_internal" {
  depends_on = [
    aws_security_group.batch
  ]

  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_security_group.batch.id
  description       = "Internal"
}
