# ----------------------------------------------------------------------------------------------
# IAM Policy - AmazonSSMDirectoryServiceAccess
# ----------------------------------------------------------------------------------------------
data "aws_iam_policy" "ssm_directory_service_access" {
  name = "AmazonSSMDirectoryServiceAccess"
}

# ----------------------------------------------------------------------------------------------
# IAM Policy - SSM
# ----------------------------------------------------------------------------------------------
data "aws_iam_policy" "ssm" {
  name = "AmazonEC2RoleforSSM"
}
