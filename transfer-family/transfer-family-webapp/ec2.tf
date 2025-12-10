# ----------------------------------------------------------------------------------------------
# EC2 - Windows Instance
# ----------------------------------------------------------------------------------------------
resource "aws_instance" "windows" {
  ami           = data.aws_ami.windows.id
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.private.id
  associate_public_ip_address = false
  
  vpc_security_group_ids = [aws_security_group.ec2.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_ssm.name
  
  key_name = var.key_name

  user_data = <<EOF
<powershell>
net user Administrator "${var.windows_admin_password}"
</powershell>
EOF

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-windows-client"
  })
}
