# ----------------------------------------------------------------------------------------------
# AWS IoT Certificate - Root CA
# ----------------------------------------------------------------------------------------------
resource "aws_secretsmanager_secret" "root_ca" {
  name        = "IOTAmazonRootCAStorage"
  description = "Store the IOT PEM file for amazon root certificate"
}

# ----------------------------------------------------------------------------------------------
# AWS IoT Certificate - Root CA Secret Value
# ----------------------------------------------------------------------------------------------
resource "aws_secretsmanager_secret_version" "root_ca" {
  secret_id     = aws_secretsmanager_secret.root_ca.id
  secret_string = <<EOT
  -----BEGIN CERTIFICATE-----
MIIDQTCCAimgAwIBAgITBmyfz5m/jAo54vB4ikPmljZbyjANBgkqhkiG9w0BAQsF
ADA5MQswCQYDVQQGEwJVUzEPMA0GA1UEChMGQW1hem9uMRkwFwYDVQQDExBBbWF6
b24gUm9vdCBDQSAxMB4XDTE1MDUyNjAwMDAwMFoXDTM4MDExNzAwMDAwMFowOTEL
MAkGA1UEBhMCVVMxDzANBgNVBAoTBkFtYXpvbjEZMBcGA1UEAxMQQW1hem9uIFJv
b3QgQ0EgMTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALJ4gHHKeNXj
ca9HgFB0fW7Y14h29Jlo91ghYPl0hAEvrAIthtOgQ3pOsqTQNroBvo3bSMgHFzZM
9O6II8c+6zf1tRn4SWiw3te5djgdYZ6k/oI2peVKVuRF4fn9tBb6dNqcmzU5L/qw
IFAGbHrQgLKm+a/sRxmPUDgH3KKHOVj4utWp+UhnMJbulHheb4mjUcAwhmahRWa6
VOujw5H5SNz/0egwLX0tdHA114gk957EWW67c4cX8jJGKLhD+rcdqsq08p8kDi1L
93FcXmn/6pUCyziKrlA4b9v7LWIbxcceVOF34GfID5yHI9Y/QCB/IIDEgEw+OyQm
jgSubJrIqg0CAwEAAaNCMEAwDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMC
AYYwHQYDVR0OBBYEFIQYzIU07LwMlJQuCFmcx7IQTgoIMA0GCSqGSIb3DQEBCwUA
A4IBAQCY8jdaQZChGsV2USggNiMOruYou6r4lK5IpDB/G/wkjUu0yKGX9rbxenDI
U5PMCCjjmCXPI6T53iHTfIUJrU6adTrCC2qJeHZERxhlbI1Bjjt/msv0tadQ1wUs
N+gDS63pYaACbvXy8MWy7Vu33PqUXHeeE6V/Uq2V8viTO96LXFvKWlJbYK8U90vv
o/ufQJVtMVT8QtPHRh8jrdkPSHCa2XV4cdFyQzR1bldZwgJcJmApzyMZFo6IQ6XU
5MsI+yMRQ+hDKXJioaldXgjUkK642M4UwtBV8ob2xJNDd2ZhwLnoQdeXeGADbkpy
rqXRfboQnoZsG4q5WTP468SQvvG5
-----END CERTIFICATE-----
EOT
}

# ----------------------------------------------------------------------------------------------
# AWS IoT Certificate - Private Key
# ----------------------------------------------------------------------------------------------
resource "aws_secretsmanager_secret" "private_key" {
  name        = "IOTPrivateCertificate"
  description = "Store the IOT PEM certificate associated with the Gateway"
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
  name        = "IOTPublicCertificate"
  description = "Store the IOT Public Key associated with the Gateway"
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
  name        = "IOTPublicCertificate"
  description = "Store the IOT PEM certificate associated with the Gateway"
}

# ----------------------------------------------------------------------------------------------
# AWS IoT Certificate - PEM Certificate
# ----------------------------------------------------------------------------------------------
resource "aws_secretsmanager_secret_version" "pem_cert" {
  secret_id     = aws_secretsmanager_secret.pem_cert.id
  secret_string = aws_iot_certificate.this.certificate_pem
}
