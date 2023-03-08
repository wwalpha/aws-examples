# ----------------------------------------------------------------------------------------------
# S3 URL - AppSpec
# ----------------------------------------------------------------------------------------------
output "appspec_s3_location" {
  value = "bucket=${aws_s3_bucket.configs.bucket},bundleType=yaml,key=${aws_s3_object.appspec.key}"
}
