# ----------------------------------------------------------------------------------------------
# AWS Directory Service
# ----------------------------------------------------------------------------------------------
resource "aws_directory_service_directory" "this" {
  name     = "${var.prefix}.local"
  password = random_password.this.result
  size     = "Small"

  vpc_settings {
    vpc_id     = var.vpc_id
    subnet_ids = var.vpc_private_subnet_ids
  }
}

# ----------------------------------------------------------------------------------------------
# Random Password
# ----------------------------------------------------------------------------------------------
resource "random_password" "this" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
