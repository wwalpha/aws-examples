# ----------------------------------------------------------------------------------------------
# AWS Security Group - Allow TLS
# ----------------------------------------------------------------------------------------------
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.networking.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.prefix}_allow_tls"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Endpoint - SSM
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = module.networking.vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.networking.vpc_private_subnet_ids
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.allow_tls.id]
  tags = {
    Name = "${var.prefix}-ssm"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Endpoint Policy - SSM
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint_policy" "ssm" {
  vpc_endpoint_id = aws_vpc_endpoint.ssm.id
  policy          = local.iam_policy
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Endpoint - EC2Messages
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = module.networking.vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.networking.vpc_private_subnet_ids
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.allow_tls.id]
  tags = {
    Name = "${var.prefix}-ec2messages"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Endpoint Policy - EC2Messages
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint_policy" "ec2messages" {
  vpc_endpoint_id = aws_vpc_endpoint.ec2messages.id
  policy          = local.iam_policy
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Endpoint - SSMMessages
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = module.networking.vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.networking.vpc_private_subnet_ids
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.allow_tls.id]
  tags = {
    Name = "${var.prefix}-ssmmessages"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Endpoint Policy - SSMMessages
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint_policy" "ssmmessages" {
  vpc_endpoint_id = aws_vpc_endpoint.ssmmessages.id
  policy          = local.iam_policy
}
