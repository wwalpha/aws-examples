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

# ----------------------------------------------------------------------------------------------
# VPC Subnets - Workload
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "workload" {
  count = length(local.subnets_cidr_block_workload_private)

  vpc_id            = aws_vpc.workload.id
  cidr_block        = element(local.subnets_cidr_block_workload_private, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = format(
      "${aws_vpc.workload.tags.Name}-private-subnets-%s",
      local.az_suffix[count.index],
    )
  }
}
