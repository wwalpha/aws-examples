# ----------------------------------------------------------------------------------------------
# VPC - Workload
# ----------------------------------------------------------------------------------------------
resource "aws_vpc" "workload" {
  cidr_block           = local.vpc_cidr_block_workload
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.prefix}-workload-vpc"
  }
}
