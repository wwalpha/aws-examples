variable "cross_account_id" {}

variable "env_name" {}

variable "rds_app_count" {
  default = 1
}

variable "rds_app_multi_az" {
  default = false
}

variable "rds_app_engine_version" {
  default = "8.0.32"
}

variable "rds_app_performance_insights_enabled" {
  default = false
}

variable "rds_app_monitoring_interval" {
  default = 0
}

variable "rds_batch_count" {
  default = 0
}

variable "rds_batch_multi_az" {
  default = false
}

variable "rds_batch_engine_version" {
  default = "8.0.32"
}

variable "rds_batch_performance_insights_enabled" {
  default = false
}

variable "rds_db_subnet_group_name" {}

variable "rds_db_parameter_group_name" {}

variable "rds_backup_retention_period_app" {
  default = 7
}

variable "rds_backup_retention_period_batch" {
  default = 7
}

variable "rds_availability_zone" {
  default = "ap-northeast-1d"
}

variable "addition_batch" {
  default = false
}

variable "autoscaling_app_instances" {
  type    = number
  default = 2
}

variable "autoscaling_proxy_instances" {
  type    = number
  default = 2
}

variable "vpc_id" {}

variable "private_subnets" {}

variable "public_subnets" {}

variable "ami_id_app" {
  default = "ami-01d86419e947d96b6"
}

variable "ami_id_proxy" {
  default = "ami-08acf46b19180cd78"
}

variable "ami_id_batch" {
  default = "ami-093b0767b5f65f5b7"
}

variable "sg_client_vpn" {}

variable "sg_vpc_endpoint" {}

variable "shared_key" {
  default = "eRZYfjb4BTftCXaBmSh5egQD6SDye43"
}

variable "web_acl_id" {
  default = "arn:aws:wafv2:us-east-1:694674946705:global/webacl/ip-restrict/91fa5ca1-db87-4f2b-9c52-66d787f5b288"
}

variable "enable_autoscaling_group_proxy" {
  default = true
}

variable "enable_autoscaling_group_app" {
  default = true
}

variable "enable_autoscaling_group_batch" {
  default = true
}


variable "ignore_asg_proxy" {
  default = false
}

variable "ignore_asg_app" {
  default = false
}

