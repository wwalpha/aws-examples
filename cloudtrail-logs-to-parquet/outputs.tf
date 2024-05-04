output "glue_workflow_id" {
  value = aws_glue_workflow.cloudtrail_parquet_glue.id
}

output "s3_bucket_etl_job_scripts" {
  value = aws_s3_bucket.etl_job_script.id
}

output "s3_bucket_glue_temp" {
  value = aws_s3_bucket.glue_temp.id
}

