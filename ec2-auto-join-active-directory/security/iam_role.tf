# ----------------------------------------------------------------------------------------------
# IAM Role - Windows
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "adminad" {
  name               = "${upper(var.prefix)}_ADAdminRole"
  assume_role_policy = data.aws_iam_policy_document.ec2.json
}

# ----------------------------------------------------------------------------------------------
# IAM Role Policy Attachment - SSM
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.adminad.name
  policy_arn = data.aws_iam_policy.ssm.arn
}

# ----------------------------------------------------------------------------------------------
# IAM Role Policy Attachment - SSM Managed Instance Core
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.adminad.name
  policy_arn = data.aws_iam_policy.ssm_managed_instance_core.arn
}

# ----------------------------------------------------------------------------------------------
# IAM Role Policy Attachment - Directory Service Access
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "directory_service_access" {
  role       = aws_iam_role.adminad.name
  policy_arn = data.aws_iam_policy.ssm_directory_service_access.arn
}
