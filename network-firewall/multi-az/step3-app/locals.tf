locals {
  user_data = <<EOT
sudo amazon-linux-extras enable nginx1
sudo amazon-linux-extras install -y nginx1 
sudo systemctl enable nginx
sudo systemctl start nginx
EOT
}
