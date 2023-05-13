# ----------------------------------------------------------------------------------------------
# AWS SSM Document
# ----------------------------------------------------------------------------------------------
resource "aws_ssm_document" "ad_join_domain" {
  name          = "ad-join-domain"
  document_type = "Command"
  content = jsonencode(
    {
      "schemaVersion" = "2.2"
      "description"   = "aws:domainJoin"
      "mainSteps" = [
        {
          "action" = "aws:domainJoin",
          "name"   = "domainJoin",
          "inputs" = {
            "directoryId" : var.ds_directory_id,
            "directoryName" : data.aws_directory_service_directory.this.name,
            "dnsIpAddresses" : sort(data.aws_directory_service_directory.this.dns_ip_addresses)
          }
        }
      ]
    }
  )
}

# ----------------------------------------------------------------------------------------------
# AWS SSM Document Association
# ----------------------------------------------------------------------------------------------
resource "aws_ssm_association" "ad_join_domain_association" {
  depends_on = [aws_instance.ad_admin]
  name       = aws_ssm_document.ad_join_domain.name

  targets {
    key    = "InstanceIds"
    values = [aws_instance.ad_admin.id]
  }
}
