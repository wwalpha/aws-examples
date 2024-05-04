# ----------------------------------------------------------------------------------------------
# AWS Glue Crawler - Cloudtrail Parquet Crawler
# ----------------------------------------------------------------------------------------------
resource "aws_glue_crawler" "cloudtrail_parquet_crawler" {
  database_name = var.glue_catalog_database
  classifiers   = []
  name          = "CloudTrailParquetCrawler_${local.suffix}"
  role          = aws_iam_role.cloudtrail_parquet_glue.arn
  table_prefix  = "cloudtrail_"

  s3_target {
    exclusions = []
    path       = var.s3_bucket_cloudtrail_parquet
  }

  configuration = jsonencode(
    {
      CrawlerOutput = {
        Partitions = {
          AddOrUpdateBehavior = "InheritFromTable"
        }
        Tables = {
          AddOrUpdateBehavior = "MergeNewColumns"
        }
      }
      Version = 1
    }
  )
  schema_change_policy {
    delete_behavior = "DEPRECATE_IN_DATABASE"
    update_behavior = "LOG"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Glue Crawler - Cloudtrail Raw Crawler
# ----------------------------------------------------------------------------------------------
resource "aws_glue_crawler" "cloudtrail_raw_crawler" {
  database_name = var.glue_catalog_database
  name          = "CloudTrailRawCrawler_${local.suffix}"
  role          = aws_iam_role.cloudtrail_parquet_glue.arn
  table_prefix  = "raw_"

  s3_target {
    path       = var.s3_bucket_cloudtrail_logs
    exclusions = ["**-Digest**", "**Config**"]
  }

  configuration = jsonencode(
    {
      Version = "1.0",
      Grouping = {
        TableGroupingPolicy = "CombineCompatibleSchemas"
      },
      CrawlerOutput = {
        Partitions = {
          AddOrUpdateBehavior = "InheritFromTable"
        }
      }
      Version = 1
    }
  )
  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "LOG"
  }
}

