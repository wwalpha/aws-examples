# ----------------------------------------------------------------------------------------------
# AWS VPC Endpoint - SSM
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.vpce_sg.id]
  subnet_ids         = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-ssm-vpce"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Endpoint - SSM Messages
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.vpce_sg.id]
  subnet_ids         = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-ssmmessages-vpce"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Endpoint - EC2 Messages
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.vpce_sg.id]
  subnet_ids         = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-ec2messages-vpce"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Endpoint - Route53
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint" "route53" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.route53"
  service_region    = "us-east-1"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.vpce_sg.id]
  subnet_ids         = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  private_dns_enabled = true


  tags = {
    Name = "${var.project_name}-route53-vpce"
  }
}
