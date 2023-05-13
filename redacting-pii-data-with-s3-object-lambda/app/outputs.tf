# ----------------------------------------------------------------------------------------------
# Object Lambda Access Point
# ----------------------------------------------------------------------------------------------
output "object_lambda_access_point" {
  value = aws_s3control_object_lambda_access_point.this
}

# ----------------------------------------------------------------------------------------------
# CloudFront Domain Name
# ----------------------------------------------------------------------------------------------
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.this.domain_name
}
