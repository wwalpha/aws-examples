# ----------------------------------------------------------------------------------------------
# AWS IAM Instance Profile - EC2 SSM
# ----------------------------------------------------------------------------------------------
resource "aws_iam_instance_profile" "this" {
  name = "ec2_ssm"
  role = var.ec2_ssm_role_name
}

# ----------------------------------------------------------------------------------------------
# AWS EC2 Instance - OnPremise DNS Server
# ----------------------------------------------------------------------------------------------
module "dns_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "${var.prefix}-onpremise-dnsserver"

  ami                    = "ami-0962657fe505b0123"
  instance_type          = "t3a.medium"
  key_name               = "onecloud"
  monitoring             = false
  vpc_security_group_ids = [module.onpremise_sg.security_group_id]
  subnet_id              = var.vpc_subnets_onpremise_private[0]
  iam_instance_profile   = aws_iam_instance_profile.this.name
  source_dest_check      = false
}

# ----------------------------------------------------------------------------------------------
# AWS EC2 Instance - OnPremise Client
# ----------------------------------------------------------------------------------------------
module "onpremise_client" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "${var.prefix}-onpremise-client"

  ami                    = "ami-0962657fe505b0123"
  instance_type          = "t3a.medium"
  key_name               = "onecloud"
  monitoring             = false
  vpc_security_group_ids = [module.onpremise_sg.security_group_id]
  subnet_id              = var.vpc_subnets_onpremise_private[0]
  iam_instance_profile   = aws_iam_instance_profile.this.name
  source_dest_check      = false
}
