# ----------------------------------------------------------------------------------------------
# AWS Glue Catalog Database - CloudTrail
# ----------------------------------------------------------------------------------------------
# resource "aws_glue_catalog_database" "this" {
#   name        = "${var.glue_catalog_database}-${local.suffix}"
#   description = "test"

#   create_table_default_permission {
#     permissions = ["SELECT"]

#     principal {
#       data_lake_principal_identifier = "IAM_ALLOWED_PRINCIPALS"
#     }
#   }
# }


# data "aws_lakeformation_permissions" "this" {
#   principal = aws_iam_role.cloudtrail_parquet_glue.arn

#   database {
#     name       = var.glue_catalog_database
#     catalog_id = "334678299258"
#   }
# }
