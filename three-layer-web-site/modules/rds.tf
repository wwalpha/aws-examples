# ----------------------------------------------------------------------------------------------
# RDS - MySQL
# ----------------------------------------------------------------------------------------------
resource "aws_db_instance" "app" {
  count                           = var.rds_app_count
  allocated_storage               = 200
  engine                          = "mysql"
  engine_version                  = var.rds_app_engine_version
  instance_class                  = lookup(local.db_instance_class, var.env_name)
  identifier                      = "honbu-${lookup(local.db_names, var.env_name)}-app"
  username                        = "admin"
  password                        = "LawDB2021+"
  parameter_group_name            = "utf8mb4v2"
  skip_final_snapshot             = true
  multi_az                        = var.rds_app_multi_az
  performance_insights_enabled    = var.rds_app_performance_insights_enabled
  monitoring_interval             = var.rds_app_monitoring_interval
  availability_zone               = var.rds_app_multi_az == false ? var.rds_availability_zone : null
  db_subnet_group_name            = var.rds_db_subnet_group_name
  vpc_security_group_ids          = [aws_security_group.db.id, var.sg_client_vpn]
  storage_encrypted               = true
  copy_tags_to_snapshot           = true
  backup_retention_period         = var.rds_backup_retention_period_app
  tags                            = {}
  enabled_cloudwatch_logs_exports = []
  auto_minor_version_upgrade      = false
  # max_allocated_storage           = 1000

  lifecycle {
    ignore_changes = [
      allocated_storage, tags, availability_zone, backup_retention_period, max_allocated_storage
    ]
  }
}

resource "aws_db_instance" "batch" {
  count                           = var.rds_batch_count
  allocated_storage               = 200
  engine                          = "mysql"
  engine_version                  = var.rds_batch_engine_version
  instance_class                  = "db.t3.medium"
  identifier                      = "honbu-${lookup(local.db_names, var.env_name)}-batch"
  username                        = "admin"
  password                        = "LawDB2021+"
  parameter_group_name            = "utf8mb4v2"
  skip_final_snapshot             = true
  db_subnet_group_name            = var.rds_db_subnet_group_name
  vpc_security_group_ids          = [aws_security_group.db.id, var.sg_client_vpn]
  storage_encrypted               = true
  availability_zone               = "ap-northeast-1d"
  multi_az                        = var.rds_batch_multi_az
  performance_insights_enabled    = var.rds_batch_performance_insights_enabled
  copy_tags_to_snapshot           = true
  backup_retention_period         = var.rds_backup_retention_period_batch
  tags                            = {}
  enabled_cloudwatch_logs_exports = []
  auto_minor_version_upgrade      = false

  lifecycle {
    ignore_changes = [
      allocated_storage, max_allocated_storage
    ]
  }
}
