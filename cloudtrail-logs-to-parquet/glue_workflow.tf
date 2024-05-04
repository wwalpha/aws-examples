# ----------------------------------------------------------------------------------------------
# AWS Glue Workflow - Cloudtrail Parquet Glue
# ----------------------------------------------------------------------------------------------
resource "aws_glue_workflow" "cloudtrail_parquet_glue" {
  name = "cloudtrail-logs-to-parquet-${local.suffix}"
}

# ----------------------------------------------------------------------------------------------
# AWS Glue Trigger - Start CloudTrail Raw to Parquet
# ----------------------------------------------------------------------------------------------
resource "aws_glue_trigger" "start_cloudtrail_raw_to_parquet" {
  name          = "StartCloudTrailRawToParquet"
  schedule      = "cron(10 12 * * ? *)"
  type          = "SCHEDULED"
  workflow_name = aws_glue_workflow.cloudtrail_parquet_glue.name

  actions {
    crawler_name = aws_glue_crawler.cloudtrail_raw_crawler.name
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Glue Trigger - Run After CloudTrail Raw Crawler Completed
# ----------------------------------------------------------------------------------------------
resource "aws_glue_trigger" "after_cloudtrail_raw_crawler" {
  name          = "AfterCloudTrailRawCrawler"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.cloudtrail_parquet_glue.name

  actions {
    job_name = "CloudTrailToParquet"
  }

  predicate {
    logical = "ANY"

    conditions {
      crawl_state      = "SUCCEEDED"
      crawler_name     = aws_glue_crawler.cloudtrail_raw_crawler.name
      logical_operator = "EQUALS"
    }
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Glue Trigger - Run After CloudTrail to Parquet Successed
# ----------------------------------------------------------------------------------------------
resource "aws_glue_trigger" "after_cloudtrail_to_parquet" {
  name          = "AfterCloudTrailToParquet"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.cloudtrail_parquet_glue.name

  actions {
    crawler_name = aws_glue_crawler.cloudtrail_parquet_crawler.name
  }

  predicate {
    logical = "ANY"
    conditions {
      job_name         = "CloudTrailToParquet"
      state            = "SUCCEEDED"
      logical_operator = "EQUALS"
    }
  }
}

