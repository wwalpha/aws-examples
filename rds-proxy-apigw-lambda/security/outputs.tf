output "iam_role_arn_ec2_ssm" {
  value = aws_iam_role.ec2_ssm.arn
}

output "iam_role_arn_rds_proxy" {
  value = aws_iam_role.rds_proxy.arn
}

output "iam_role_arn_lambda_app" {
  value = aws_iam_role.lambda_app.arn
}

output "iam_role_profile_ec2_ssm" {
  value = aws_iam_instance_profile.ec2_ssm.name
}
