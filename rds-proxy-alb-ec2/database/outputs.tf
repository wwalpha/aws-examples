output "aws_rds_proxy" {
  value = aws_db_proxy.this
}

output "aws_rds_instance" {
  value = aws_db_instance.this
}

output "aws_rds_proxy_sg" {
  value = aws_security_group.rds_proxy
}
