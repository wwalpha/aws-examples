# ----------------------------------------------------------------------------------------------
# AWS Security Group - Inbound Endpoint Security Group
# ----------------------------------------------------------------------------------------------
module "inbound_endpoint_sg" {
  source = "terraform-aws-modules/security-group/aws"
  name   = "${var.prefix}_inbound_endpoint_sg"
  vpc_id = aws_vpc.central_dns.id

  ingress_with_cidr_blocks = [
    {
      rule        = "dns-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "dns-udp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - Outbound Endpoint Security Group
# ----------------------------------------------------------------------------------------------
module "outbound_endpoint_sg" {
  source = "terraform-aws-modules/security-group/aws"
  name   = "${var.prefix}_outbound_endpoint_sg"
  vpc_id = aws_vpc.central_dns.id

  ingress_with_cidr_blocks = [
    {
      rule        = "dns-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "dns-udp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
