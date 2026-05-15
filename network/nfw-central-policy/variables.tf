# Deployment settings
variable "aws_region" {
  description = "AWS region where the demo environment is deployed."
  type        = string
  default     = "ap-northeast-1"
}

variable "name_prefix" {
  description = "Prefix used in resource names."
  type        = string
  default     = "nfw-demo"
}

variable "instance_type" {
  description = "EC2 instance type for the private NGINX instance."
  type        = string
  default     = "t3.micro"
}

# Explicit waits for dependent runtime paths
variable "nat_gateway_wait_duration" {
  description = "Explicit wait after NAT Gateway creation."
  type        = string
  default     = "90s"
}

variable "egress_path_wait_duration" {
  description = "Explicit wait after egress route wiring before EC2 creation."
  type        = string
  default     = "120s"
}

variable "log_retention_days" {
  description = "Retention for Network Firewall CloudWatch Logs."
  type        = number
  default     = 7
}
