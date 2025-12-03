
# ----------------------------------------------------------------------------------------------
# AWS Instance - Test Server
# ----------------------------------------------------------------------------------------------
resource "aws_instance" "test_server" {
  ami           = data.aws_ami.al2023.id
  instance_type = "t3.micro"

  subnet_id              = aws_subnet.private_1.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "${var.project_name}-test-server"
  }
}
