locals {
  prefix = "monitoring"

  lambda_handler = "index.handler"
  lambda_runtime = "nodejs20.x"
}

# ----------------------------------------------------------------------------------------------
# AWS IAM Policy Document - CodeBuild
# ----------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "codebuild" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
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
# AWS IAM Policy Document - lambda
# ----------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "lambda" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
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
