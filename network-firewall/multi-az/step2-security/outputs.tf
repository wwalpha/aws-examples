output "ec2_ssm_role" {
  value = aws_iam_role.ec2_ssm
}

output "ec2_ssm_role_profile" {
  value = aws_iam_instance_profile.ec2_ssm
}
