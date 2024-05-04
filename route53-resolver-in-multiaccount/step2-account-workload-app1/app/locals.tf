locals {
  user_data_nginx = <<EOT
dnf install -y nginx
systemctl enable nginx
systemctl start nginx
EOT
}
