variable "prefix" {}

variable "vpc_id_ingress" {}

variable "vpc_id_workload_intra" {}

variable "vpc_id_workload_web" {}

variable "vpc_subnets_workload_web_public" {}

variable "vpc_subnets_workload_web_private" {}

variable "vpc_subnets_workload_intra_private" {}

variable "vpc_subnets_ingress_public" {}

variable "ec2_ssm_role_name" {}
