locals {
  proxy_user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y amazon-ssm-agent
amazon-linux-extras install -y nginx1
echo -e "server { location / { proxy_pass http://${module.aws_application.private_ip}/; }}" > /etc/nginx/conf.d/proxy.conf
systemctl start nginx
systemctl enable nginx
EOF

  openswan_user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y amazon-ssm-agent openswan
systemctl enable ipsec
systemctl start ipsec
EOF

  application_user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y amazon-ssm-agent
amazon-linux-extras install -y nginx1
systemctl start nginx
systemctl enable nginx
echo "Application host on AWS" > /usr/share/nginx/html/index.html
EOF
}
