locals {
  user_data_nginx = <<EOT
amazon-linux-extras enable nginx1
amazon-linux-extras install -y nginx1 
systemctl enable nginx
systemctl start nginx
EOT

  user_data_apache = <<EOT
yum install -y httpd
systemctl enable httpd
systemctl start httpd
EOT
}
