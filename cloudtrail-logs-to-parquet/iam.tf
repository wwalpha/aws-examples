# ----------------------------------------------------------------------------------------------
# AWS IAM Role - Cloudtrail Parquet Glue
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "cloudtrail_parquet_glue" {
  name               = "AWSGlueServiceRole-CloudTrailToParquet"
  assume_role_policy = data.aws_iam_policy_document.glue.json
}

resource "aws_iam_role_policy_attachment" "cloudtrail_parquet_glue" {
  role       = aws_iam_role.cloudtrail_parquet_glue.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "glue_s3_permissions" {
  name = "s3_policy"
  role = aws_iam_role.cloudtrail_parquet_glue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetBucketLocation",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:PutObject"
        ]
        Resource = "*"
      },
    ]
  })
}
