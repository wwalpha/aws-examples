variable "prefix" {}

variable "vpc_id" {}

variable "public_subnets" {}

variable "private_subnets" {}

variable "private_subnet_cidr_block" {}

variable "iam_role_profile_ec2_ssm" {}

variable "database_proxy_sg_id" {}

variable "database_proxy_endpoint" {}

variable "database_username" {}

variable "database_password" {}

variable "lambda_module_bucket_name" {}

variable "lambda_module_bucket_key" {}

variable "lambda_module_version_id" {}

variable "iam_role_arn_lambda_app" {}
