resource "aws_db_instance" "this" {
  allocated_storage            = 100
  identifier                   = "${var.prefix}-postgres"
  engine                       = "postgres"
  engine_version               = "13.7"
  instance_class               = "db.t3.medium"
  username                     = var.database_username
  password                     = var.database_password
  parameter_group_name         = "default.postgres13"
  db_subnet_group_name         = aws_db_subnet_group.this.name
  vpc_security_group_ids       = [aws_security_group.rds.id]
  skip_final_snapshot          = true
  performance_insights_enabled = false
  storage_encrypted            = true
  copy_tags_to_snapshot        = true
  backup_retention_period      = 7
  apply_immediately            = true
}

