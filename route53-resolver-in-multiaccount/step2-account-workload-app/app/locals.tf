# locals {
#   user_data_nginx = <<EOT
# #!/bin/bash
# sudo dnf install -y nginx
# sudo systemctl enable nginx
# sudo systemctl start nginx
# EOT
# }
locals {
  user_data_nginx = <<EOT
sudo dnf install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
EOT
}
