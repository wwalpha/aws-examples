# ----------------------------------------------------------------------------------------------
# AWS CodeBuild Project
# ----------------------------------------------------------------------------------------------
resource "aws_codebuild_project" "this" {
  name         = "${local.prefix}_BuildProject"
  description  = "codebuild_project"
  service_role = aws_iam_role.codebuild.arn

  source {
    type      = "NO_SOURCE"
    buildspec = <<EOT
version: 0.2

phases:
  install:
    runtime-versions:
      python: 3.12
    commands:
      - pip3 install checkov --quiet
  build:
    commands:
      - aws s3 cp s3://$BUCKET_NAME/$OBJECT_KEY .
      - checkov -f $OBJECT_KEY
EOT
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    # environment_variable {
    #   name  = "BUCKET_NAME"
    #   value = aws_s3_bucket.this.bucket
    # }

    # environment_variable {
    #   name  = "OBJECT_KEY"
    #   value = "SOME_VALUE2"
    # }
  }

  cache {
    type = "NO_CACHE"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      status = "DISABLED"
    }
  }
}


