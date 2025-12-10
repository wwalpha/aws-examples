locals {
  prefix = "rdsevents"
}

# ----------------------------------------------------------------------------------------------
# AWS IAM Policy Document - Step Function
# ----------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "sfn" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# ----------------------------------------------------------------------------------------------
# AWS IAM Policy Document - events
# ----------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "events" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
