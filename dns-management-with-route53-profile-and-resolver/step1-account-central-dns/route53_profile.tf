# ----------------------------------------------------------------------------------------------
# AWS Route53 Profile
# ----------------------------------------------------------------------------------------------
resource "null_resource" "route53_profile" {
  provisioner "local-exec" {
    command = "sh ${path.module}/scripts/createProfile.sh"

    environment = {
      PROFILE_NAME = "${var.prefix}-profile"
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "sh ${path.module}/scripts/deleteProfile.sh"
  }
}


