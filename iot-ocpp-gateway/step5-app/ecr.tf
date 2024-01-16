# ----------------------------------------------------------------------------------------------
# ECR Repository
# ----------------------------------------------------------------------------------------------
resource "aws_ecr_repository" "this" {
  name                 = "${lower(var.prefix)}-gateway"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = false
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ----------------------------------------------------------------------------------------------
# Null Resource
# ----------------------------------------------------------------------------------------------
resource "null_resource" "docker_image" {
  triggers = {
    shell_md5 = md5(file("${path.module}/scripts/dockerbuild.sh"))
  }

  provisioner "local-exec" {
    command = "sh ${path.module}/scripts/dockerbuild.sh"

    environment = {
      AWS_REGION     = local.region
      AWS_ACCOUNT_ID = local.account_id
      REPO_URL       = aws_ecr_repository.this.repository_url
    }
  }
}
