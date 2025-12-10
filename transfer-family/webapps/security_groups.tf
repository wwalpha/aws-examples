# ----------------------------------------------------------------------------------------------
# Security Groups - EC2
# ----------------------------------------------------------------------------------------------
resource "aws_security_group" "ec2" {
  name        = "${local.name_prefix}-ec2-sg"
  description = "Security group for Windows EC2"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "RDP from allowed CIDR"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-ec2-sg"
  })
}

# ----------------------------------------------------------------------------------------------
# Security Groups - Transfer Family
# ----------------------------------------------------------------------------------------------
resource "aws_security_group" "transfer" {
  name        = "${local.name_prefix}-transfer-sg"
  description = "Security group for Transfer Family Server"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "SFTP from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "HTTPS from VPC (for Web App if applicable)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-transfer-sg"
  })
}

# ----------------------------------------------------------------------------------------------
# Security Groups - VPC Endpoints
# ----------------------------------------------------------------------------------------------
resource "aws_security_group" "vpce" {
  name        = "${local.name_prefix}-vpce-sg"
  description = "Security group for VPC Endpoints"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-vpce-sg"
  })
}
