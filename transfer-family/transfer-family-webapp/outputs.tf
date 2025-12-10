# ----------------------------------------------------------------------------------------------
# Outputs
# ----------------------------------------------------------------------------------------------
output "transfer_server_endpoint" {
  description = "Transfer Family Server Endpoint"
  value       = aws_transfer_server.this.endpoint
}

output "transfer_server_id" {
  description = "Transfer Family Server ID"
  value       = aws_transfer_server.this.id
}

output "ec2_instance_id" {
  description = "Windows EC2 Instance ID"
  value       = aws_instance.windows.id
}

output "ec2_public_ip" {
  description = "Windows EC2 Public IP"
  value       = aws_instance.windows.public_ip
}

output "s3_bucket_name" {
  description = "S3 Bucket Name"
  value       = aws_s3_bucket.transfer.id
}

output "identity_center_instance_arn" {
  description = "Identity Center Instance ARN"
  value       = try(data.aws_ssoadmin_instances.this.arns[0], "Not found")
}
