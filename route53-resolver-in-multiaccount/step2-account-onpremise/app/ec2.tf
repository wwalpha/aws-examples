# ----------------------------------------------------------------------------------------------
# AWS IAM Instance Profile - EC2 SSM
# ----------------------------------------------------------------------------------------------
resource "aws_iam_instance_profile" "this" {
  name = "ec2_ssm"
  role = aws_iam_role.ec2_ssm.name
}

# ----------------------------------------------------------------------------------------------
# AWS EC2 Instance - DNS Server
# ----------------------------------------------------------------------------------------------
module "dns_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "${var.prefix}-dnsserver"

  ami                    = "ami-0962657fe505b0123"
  instance_type          = "t3a.medium"
  key_name               = "resolver-testing"
  monitoring             = false
  vpc_security_group_ids = [module.onpremise_sg.security_group_id]
  subnet_id              = var.vpc_private_subnet_ids[0]
  iam_instance_profile   = aws_iam_instance_profile.this.name
  source_dest_check      = false
  user_data              = local.user_data_dns_server
  private_ip             = var.dns_server_ip
}

# ----------------------------------------------------------------------------------------------
# AWS EC2 Instance - Client
# ----------------------------------------------------------------------------------------------
module "onpremise_client" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "${var.prefix}-client"

  ami                    = "ami-0962657fe505b0123"
  instance_type          = "t3a.medium"
  key_name               = "resolver-testing"
  monitoring             = false
  vpc_security_group_ids = [module.onpremise_sg.security_group_id]
  subnet_id              = var.vpc_private_subnet_ids[0]
  iam_instance_profile   = aws_iam_instance_profile.this.name
  source_dest_check      = false
  user_data              = local.user_data_dns_client
}
