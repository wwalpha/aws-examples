# ----------------------------------------------------------------------------------------------
# AWS IAM Policy Document - EC2
# ----------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "ec2" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# ----------------------------------------------------------------------------------------------
# AWS IAM Policy Document - IoT
# ----------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "iot" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["iot.amazonaws.com"]
    }
  }
}

# ----------------------------------------------------------------------------------------------
# AWS IAM Policy Document - Lambda
# ----------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "lambda" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# ----------------------------------------------------------------------------------------------
# AWS IAM Policy Document - ECS Task
# ----------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "ecs_task" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ----------------------------------------------------------------------------------------------
# AWS IAM Policy Document - Dynamodb
# ----------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "dynamodb" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["dynamodb.amazonaws.com"]
    }
  }
}
