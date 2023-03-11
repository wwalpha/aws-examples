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

# create sample database
psql -d postgres -c "create database dvdrental;"
pg_restore -d dvdrental dvdrental.tar
psql -d dvdrental -c "\dt"

# install sample source
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

resource "time_sleep" "wait_120_seconds" {
  create_duration = "120s"
}

module "ec2_instance" {
  depends_on = [time_sleep.wait_120_seconds]
  source     = "terraform-aws-modules/ec2-instance/aws"
  version    = "~> 3.0"

  name                   = "${var.prefix}-instance"
  ami                    = "ami-0404778e217f54308"
  instance_type          = "t3a.medium"
  key_name               = "onecloud"
  monitoring             = false
  vpc_security_group_ids = [module.app_sg.security_group_id]
  subnet_id              = var.private_subnets[0]
  user_data_base64       = base64encode(local.user_data)
  iam_instance_profile   = var.iam_role_profile_ec2_ssm
}
