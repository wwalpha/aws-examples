locals {
  user_data = <<EOT
#!/bin/bash
yum update -y
amazon-linux-extras install -y postgresql13

# install nodejs
curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
yum install -y git nodejs yarn
npm install -g typescript ts-node forever

# export environment variables
export PGUSER=${var.database_username}
export PGPASSWORD=${var.database_password}
export PGHOST=${var.database_proxy_endpoint}

# download postgresql sample database
curl -O https://www.postgresqltutorial.com/wp-content/uploads/2019/05/dvdrental.zip
unzip dvdrental.zip

echo "Create sample database"
psql -d postgres -c "create database dvdrental;"
pg_restore -d dvdrental dvdrental.tar
psql -d dvdrental -c "\dt"

echo "Install sample source"
git clone https://github.com/wwalpha/nodejs-postgresql-samples.git
cd nodejs-postgresql-samples
yarn install

# export environment variables to env file
echo "PGUSER=${var.database_username}" > .env
echo "PGPASSWORD=${var.database_password}" >> .env
echo "PGHOST=${var.database_proxy_endpoint}" >> .env
echo "PGDATABASE=dvdrental" >> .env
echo "PGPORT=5432" >> .env

# start app in background
forever start -c "yarn start" ./

# sudo tail /var/log/cloud-init-output.log -n 20
EOT
}

resource "aws_key_pair" "this" {
  key_name   = "${var.prefix}_dummy_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}

module "ec2_instance" {
  depends_on             = [var.database_proxy_target]
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 3.0"
  name                   = "${var.prefix}-instance"
  ami                    = "ami-0404778e217f54308"
  instance_type          = "t3a.medium"
  key_name               = aws_key_pair.this.key_name
  monitoring             = false
  vpc_security_group_ids = [module.app_sg.security_group_id]
  subnet_id              = var.private_subnets[0]
  user_data_base64       = base64encode(local.user_data)
  iam_instance_profile   = var.iam_role_profile_ec2_ssm
}
