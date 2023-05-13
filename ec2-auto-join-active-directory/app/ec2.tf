# ----------------------------------------------------------------------------------------------
# EC2 Instance - Windows
# ----------------------------------------------------------------------------------------------
resource "aws_instance" "ad_admin" {
  ami                         = var.ami_id_windows
  instance_type               = "t3a.medium"
  iam_instance_profile        = aws_iam_instance_profile.windows.name
  associate_public_ip_address = false
  vpc_security_group_ids      = [module.windows_sg.security_group_id]
  subnet_id                   = var.vpc_private_subnet_ids[0]
  key_name                    = aws_key_pair.this.key_name

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_type           = "gp3"
    volume_size           = 30
  }

  tags = {
    Name = "${var.prefix}-adadmin"
  }
}

# ----------------------------------------------------------------------------------------------
# IAM Instance Profile - Windows
# ----------------------------------------------------------------------------------------------
resource "aws_iam_instance_profile" "windows" {
  name = "${var.prefix}_windows_profile"
  role = split("/", var.iam_role_arn_adminad)[1]
}


# ----------------------------------------------------------------------------------------------
# Windows Security Group
# ----------------------------------------------------------------------------------------------
module "windows_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name                = "${var.prefix}-windows-sg"
  vpc_id              = var.vpc_id
  ingress_rules       = ["all-all"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
}
