# ----------------------------------------------------------------------------------------------
# AWS CodeBuild Project
# ----------------------------------------------------------------------------------------------
resource "aws_codebuild_project" "this" {
  name          = "${local.prefix}BuildProject"
  description   = "codebuild_project"
  build_timeout = 10
  service_role  = aws_iam_role.codebuild.arn

  source {
    type     = "S3"
    location = "${aws_s3_bucket.this.bucket}/modules/"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "BUCKET_NAME"
      value = aws_s3_bucket.this.bucket
    }

    # environment_variable {
    #   name  = "SOME_KEY2"
    #   value = "SOME_VALUE2"
    #   type  = "PARAMETER_STORE"
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


