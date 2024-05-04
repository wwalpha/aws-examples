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
