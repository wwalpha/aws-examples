# ----------------------------------------------------------------------------------------------
# AWS Security Group - RDS
# ----------------------------------------------------------------------------------------------
resource "aws_security_group" "rds" {
  name   = "rds_sg"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "rds" {
  security_group_id        = aws_security_group.rds.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = aws_security_group.rds_proxy.id
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - RDS Proxy
# ----------------------------------------------------------------------------------------------
resource "aws_security_group" "rds_proxy" {
  name   = "rds_proxy_sg"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "rds_proxy_ingress" {
  security_group_id = aws_security_group.rds_proxy.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 5432
  to_port           = 5432
}

resource "aws_security_group_rule" "rds_proxy_egress" {
  security_group_id        = aws_security_group.rds_proxy.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = aws_security_group.rds.id
}

