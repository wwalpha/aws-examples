# ----------------------------------------------------------------------------------------------
# Variables
# ----------------------------------------------------------------------------------------------
variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-northeast-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "transfer-webapp-demo"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "allowed_cidr" {
  description = "CIDR allowed to access EC2 (e.g. your IP)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = null
}

variable "user_name" {
  description = "Identity Center User Name"
  type        = string
  default     = "test_user"
}

variable "group_name" {
  description = "Identity Center Group Name"
  type        = string
  default     = "test_group"
}

variable "user_email" {
  description = "Identity Center User Email"
  type        = string
  default     = "test_user@example.com"
}

variable "user_given_name" {
  description = "Identity Center User Given Name"
  type        = string
  default     = "Test"
}

variable "user_family_name" {
  description = "Identity Center User Family Name"
  type        = string
  default     = "User"
}

variable "windows_admin_password" {
  description = "Password for Windows Administrator"
  type        = string
  default     = "Password123!"
  sensitive   = true
}
