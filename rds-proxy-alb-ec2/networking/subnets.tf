# ----------------------------------------------------------------------------------------------
# AWS Subnet - database
# ----------------------------------------------------------------------------------------------
resource "aws_subnet" "database" {
  count             = length(local.availability_zones)
  vpc_id            = module.vpc.vpc_id
  cidr_block        = local.database_subnets_cidr_block[count.index]
  availability_zone = local.availability_zones[count.index]

  tags = {
    Name = format(
      "rds-database-%s",
      element(local.availability_zones, count.index),
    )
  }
}
