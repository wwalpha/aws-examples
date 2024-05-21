locals {
  suffix = random_id.this.hex

  user_data_nginx = <<EOT
#!/bin/bash
dnf install -y nginx
systemctl enable nginx
systemctl start nginx
EOT
}

# ----------------------------------------------------------------------------------------------
# Bucket Random Id
# ----------------------------------------------------------------------------------------------
resource "random_id" "this" {
  byte_length = 3
}
