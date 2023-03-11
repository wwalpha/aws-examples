# ----------------------------------------------------------------------------------------------
# AWS Security Group - Allow TLS
# ----------------------------------------------------------------------------------------------
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Endpoint - SSM
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.allow_tls.id]
  tags = {
    Name = "anfw_ssm"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Endpoint Policy - SSM
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint_policy" "ssm" {
  vpc_endpoint_id = aws_vpc_endpoint.ssm.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "*",
        "Resource" : "*"
      }
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Endpoint - EC2Messages
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.allow_tls.id]
  tags = {
    Name = "anfw_ec2messages"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Endpoint Policy - EC2Messages
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint_policy" "ec2messages" {
  vpc_endpoint_id = aws_vpc_endpoint.ec2messages.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "*",
        "Resource" : "*"
      }
    ]
  })
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Endpoint - SSMMessages
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.allow_tls.id]
  tags = {
    Name = "anfw_ssmmessages"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Endpoint Policy - SSMMessages
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint_policy" "ssmmessages" {
  vpc_endpoint_id = aws_vpc_endpoint.ssmmessages.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "*",
        "Resource" : "*"
      }
    ]
  })
}
