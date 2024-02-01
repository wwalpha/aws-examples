module "ec2_instance1" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "nfw-instance1"

  ami                    = "ami-0404778e217f54308"
  instance_type          = "t3a.medium"
  key_name               = "onecloud"
  monitoring             = false
  vpc_security_group_ids = [module.app_sg.security_group_id]
  subnet_id              = var.private_subnets[0]
  iam_instance_profile   = aws_iam_instance_profile.this.name
}


