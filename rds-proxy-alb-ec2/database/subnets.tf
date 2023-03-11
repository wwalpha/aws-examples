resource "aws_db_subnet_group" "this" {
  name       = "${var.prefix}-rds-subnets"
  subnet_ids = var.database_subnet_ids
}
