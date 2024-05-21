# variable "aws_account_id_central_dns" {
# }

# variable "aws_account_id_onpremise" {
# }

# variable "aws_account_id_workload_app1" {
# }

# variable "aws_account_id_workload_app2" {
# }

# variable "route53_profile_arn" {
# }

variable "aws_domain_name" {
  default = "master.aws"
}

variable "onpremise_domain_name" {
  default = "master.local"
}

variable "ec2_keypair_name" {
  default = "centraldns"
}
