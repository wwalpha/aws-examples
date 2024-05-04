variable "region" {
  description = "AWS region for deploying Glue infrastructure"
  default     = "us-east-1"
}

variable "s3_bucket_cloudtrail_logs" {
  type        = string
  description = "S3 bucket used for CloudTrail logs"
  default     = "s3://arms-terraform-0606/cloudtrail-global/"
}

variable "s3_bucket_cloudtrail_parquet" {
  type        = string
  description = "S3 bucket used for results of Glue ETL job"
  default     = "s3://arms-terraform-0606/cloudtrail-parquet/"
}

variable "glue_catalog_database" {
  type        = string
  description = "Glue database to use for CloudTrail crawler"
  default     = "cloudtrail-database"
}
