# ----------------------------------------------------------------------------------------------
# IAM Policy - AmazonSSMManagedInstanceCore
# ----------------------------------------------------------------------------------------------
data "aws_iam_policy" "ssm_managed_instance_core" {
  name = "AmazonSSMManagedInstanceCore"
}

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
