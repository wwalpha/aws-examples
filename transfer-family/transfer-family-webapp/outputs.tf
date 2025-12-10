# ----------------------------------------------------------------------------------------------
# Outputs
# ----------------------------------------------------------------------------------------------
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

output "webapp_id" {
  description = "Transfer Family Web App ID"
  value       = awscc_transfer_web_app.this.web_app_id
}

output "webapp_arn" {
  description = "Transfer Family Web App ARN"
  value       = awscc_transfer_web_app.this.arn
}

output "webapp_endpoint" {
  description = "Transfer Family Web App Access Endpoint"
  value       = awscc_transfer_web_app.this.access_endpoint
}
