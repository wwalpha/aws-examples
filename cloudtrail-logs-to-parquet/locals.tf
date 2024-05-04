resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

locals {
  suffix                = random_string.suffix.id
  s3_bucket_etl_scripts = "cloudtrail-etl-scripts-${local.suffix}"
  s3_bucket_glue_temp   = "cloudtrail-glue-temp-${local.suffix}"
}
