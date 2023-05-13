# ----------------------------------------------------------------------------------------------
# S3 Bucket Name
# ----------------------------------------------------------------------------------------------
output "s3_bucket_name" {
  value = aws_s3_bucket.this.id
}

# ----------------------------------------------------------------------------------------------
# S3 Access Point
# ----------------------------------------------------------------------------------------------
output "s3_ascess_point_arn" {
  value = aws_s3_access_point.this.arn
}
