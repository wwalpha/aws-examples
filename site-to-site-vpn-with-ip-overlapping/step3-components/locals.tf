locals {
  proxy_user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y amazon-ssm-agent
amazon-linux-extras install -y nginx1
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
}
