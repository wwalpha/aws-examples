# ----------------------------------------------------------------------------------------------
# AWS IoT Certificate - Root CA
# ----------------------------------------------------------------------------------------------
resource "aws_secretsmanager_secret" "root_ca" {
  name                    = "IOTAmazonRootCAStorage1"
  description             = "Store the IOT PEM file for amazon root certificate"
  recovery_window_in_days = 0
}

# ----------------------------------------------------------------------------------------------
# AWS IoT Certificate - Root CA Secret Value
# ----------------------------------------------------------------------------------------------
resource "aws_secretsmanager_secret_version" "root_ca" {
  secret_id     = aws_secretsmanager_secret.root_ca.id
  secret_string = file("${path.module}/AmazonRootCA.pem")
}

# ----------------------------------------------------------------------------------------------
# AWS IoT Certificate - Private Key
# ----------------------------------------------------------------------------------------------
resource "aws_secretsmanager_secret" "private_key" {
  name                    = "IOTPrivateCertificate1"
  description             = "Store the IOT PEM certificate associated with the Gateway"
  recovery_window_in_days = 0
}

# ----------------------------------------------------------------------------------------------
# AWS IoT Certificate - Private Key
# ----------------------------------------------------------------------------------------------
resource "aws_secretsmanager_secret_version" "private_key" {
  secret_id     = aws_secretsmanager_secret.private_key.id
  secret_string = aws_iot_certificate.this.private_key
}

# ----------------------------------------------------------------------------------------------
# AWS IoT Certificate - Public Key
# ----------------------------------------------------------------------------------------------
resource "aws_secretsmanager_secret" "public_key" {
  name                    = "IOTPublicCertificate1"
  description             = "Store the IOT Public Key associated with the Gateway"
  recovery_window_in_days = 0
}

# ----------------------------------------------------------------------------------------------
# AWS IoT Certificate - Public Key
# ----------------------------------------------------------------------------------------------
resource "aws_secretsmanager_secret_version" "public_key" {
  secret_id     = aws_secretsmanager_secret.public_key.id
  secret_string = aws_iot_certificate.this.public_key
}

# ----------------------------------------------------------------------------------------------
# AWS IoT Certificate - PEM Certificate
# ----------------------------------------------------------------------------------------------
resource "aws_secretsmanager_secret" "pem_cert" {
  name                    = "IOTPemCertificate"
  description             = "Store the IOT PEM certificate associated with the Gateway"
  recovery_window_in_days = 0
}

# ----------------------------------------------------------------------------------------------
# AWS IoT Certificate - PEM Certificate
# ----------------------------------------------------------------------------------------------
resource "aws_secretsmanager_secret_version" "pem_cert" {
  secret_id     = aws_secretsmanager_secret.pem_cert.id
  secret_string = aws_iot_certificate.this.certificate_pem
}
