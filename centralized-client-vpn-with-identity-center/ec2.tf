# ----------------------------------------------------------------------------------------------
# AWS IAM Instance Profile - EC2 SSM
# ----------------------------------------------------------------------------------------------
resource "aws_iam_instance_profile" "this" {
  name = "ec2_ssm"
  role = aws_iam_role.ec2_ssm.name
}

# ----------------------------------------------------------------------------------------------
# AWS EC2 Instance - Server01
# ----------------------------------------------------------------------------------------------
module "server01" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 3.0"
  name                   = "${var.prefix}-server01"
  ami                    = var.al2023_ami_id
  instance_type          = "t3a.small"
  key_name               = var.ec2_keypair_name
  vpc_security_group_ids = [module.vpc01_sg.security_group_id]
  subnet_id              = module.vpc_01.private_subnets[0]
  iam_instance_profile   = aws_iam_instance_profile.this.name
  source_dest_check      = false
  monitoring             = false
}

# ----------------------------------------------------------------------------------------------
# AWS EC2 Instance - Server02
# ----------------------------------------------------------------------------------------------
module "server02" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 3.0"
  name                   = "${var.prefix}-server02"
  ami                    = var.al2023_ami_id
  instance_type          = "t3a.small"
  key_name               = var.ec2_keypair_name
  vpc_security_group_ids = [module.vpc02_sg.security_group_id]
  subnet_id              = module.vpc_02.private_subnets[0]
  iam_instance_profile   = aws_iam_instance_profile.this.name
  source_dest_check      = false
  monitoring             = false
}

# ----------------------------------------------------------------------------------------------
# AWS Security Group - VPC01
# ----------------------------------------------------------------------------------------------
module "vpc01_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_vpc01_sg"
  vpc_id = module.vpc_01.vpc_id
  ingress_with_cidr_blocks = [
    {
      rule        = "all-icmp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "all-all"
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
# AWS Security Group - VPC02
# ----------------------------------------------------------------------------------------------
module "vpc02_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_vpc02_sg"
  vpc_id = module.vpc_02.vpc_id
  ingress_with_cidr_blocks = [
    {
      rule        = "all-icmp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "all-all"
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
