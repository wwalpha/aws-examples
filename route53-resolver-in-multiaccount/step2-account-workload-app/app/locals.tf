locals {
  user_data_nginx = <<EOT
#!/bin/bash
dnf install -y nginx
systemctl enable nginx
systemctl start nginx
EOT
}
