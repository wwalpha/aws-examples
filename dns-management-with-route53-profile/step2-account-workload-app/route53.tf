# ----------------------------------------------------------------------------------------------
# AWS Route53 Profile Associcate
# ----------------------------------------------------------------------------------------------
resource "null_resource" "route53_profile_associate" {
  triggers = {
    RESOURCE_ID = module.networking.vpc_id
  }

  provisioner "local-exec" {
    command = "sh ${path.module}/scripts/associateProfile.sh"

    environment = {
      NAME        = self.triggers.RESOURCE_ID
      RESOURCE_ID = self.triggers.RESOURCE_ID
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "sh ${path.module}/scripts/disassociateProfile.sh"

    environment = {
      RESOURCE_ID = self.triggers.RESOURCE_ID
    }
  }
}
