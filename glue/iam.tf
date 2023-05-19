# ----------------------------------------------------------------------------------------------
# IAM Role - Glue Crawler
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "raw_crawler" {
  name               = "GlueCrawlerRole"
  assume_role_policy = data.aws_iam_policy_document.glue.json
}

# ----------------------------------------------------------------------------------------------
# AWS Role Policy - Crawler
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "glue_crawler" {
  role       = aws_iam_role.raw_crawler.name
  policy_arn = aws_iam_policy.glue_crawler.arn
}

# ----------------------------------------------------------------------------------------------
# AWS IAM Policy Document - Glue
# ----------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "glue" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

# ----------------------------------------------------------------------------------------------
# AWS IAM Policy Document - Glue Crawler
# ----------------------------------------------------------------------------------------------
resource "aws_iam_policy" "glue_crawler" {
  name = "crawler_policy"
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "glue:GetDatabase",
          "glue:GetTable",
          "glue:CreateTable",
          "glue:CreateDatabase",
        ]
        Resource = "*"
      }
    ]
  })
}


# ----------------------------------------------------------------------------------------------
# IAM Role - Glue Job
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "raw_etl_job" {
  name               = "GlueETLJobRole"
  assume_role_policy = data.aws_iam_policy_document.glue.json
}

# ----------------------------------------------------------------------------------------------
# AWS Role Policy - Glue Job
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "raw_etl_job" {
  role       = aws_iam_role.raw_etl_job.name
  policy_arn = aws_iam_policy.glue_etl.arn
}


# ----------------------------------------------------------------------------------------------
# AWS IAM Policy Document - Glue ETL JOB
# ----------------------------------------------------------------------------------------------
resource "aws_iam_policy" "glue_etl" {
  name = "glue_etl_policy"
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "glue:GetDatabase",
          "glue:GetTable",
          "glue:CreateTable",
          "glue:CreateDatabase",
          "glue:GetPartitions",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
        ]
        Resource = "*"
      },
    ]
  })
}
