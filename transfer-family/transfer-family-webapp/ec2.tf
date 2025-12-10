# ----------------------------------------------------------------------------------------------
# EC2 - Windows Instance
# ----------------------------------------------------------------------------------------------
resource "aws_instance" "windows" {
  ami           = data.aws_ami.windows.id
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.public.id
  
  vpc_security_group_ids = [aws_security_group.ec2.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_ssm.name
  
  key_name = var.key_name

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-windows-client"
  })
}
