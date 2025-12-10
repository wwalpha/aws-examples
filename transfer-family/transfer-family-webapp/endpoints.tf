# ----------------------------------------------------------------------------------------------
# VPC Endpoints - SSM
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private.id]
  security_group_ids  = [aws_security_group.vpce.id]
  private_dns_enabled = true
  tags                = merge(local.tags, { Name = "${local.name_prefix}-ssm-vpce" })
}

# ----------------------------------------------------------------------------------------------
# VPC Endpoints - EC2 Messages
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private.id]
  security_group_ids  = [aws_security_group.vpce.id]
  private_dns_enabled = true
  tags                = merge(local.tags, { Name = "${local.name_prefix}-ec2messages-vpce" })
}

# ----------------------------------------------------------------------------------------------
# VPC Endpoints - SSM Messages
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private.id]
  security_group_ids  = [aws_security_group.vpce.id]
  private_dns_enabled = true
  tags                = merge(local.tags, { Name = "${local.name_prefix}-ssmmessages-vpce" })
}

# ----------------------------------------------------------------------------------------------
# VPC Endpoints - S3
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id, aws_route_table.public.id]
  tags              = merge(local.tags, { Name = "${local.name_prefix}-s3-vpce" })
}

# ----------------------------------------------------------------------------------------------
# VPC Endpoints - Transfer Family
# ----------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint" "transfer" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${var.region}.transfer"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private.id]
  security_group_ids  = [aws_security_group.vpce.id]
  private_dns_enabled = true
  tags                = merge(local.tags, { Name = "${local.name_prefix}-transfer-vpce" })
}
