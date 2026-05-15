locals {
  # CIDR blocks and AZ layout
  workload_vpc_cidr = "10.10.1.0/24"
  egress_vpc_cidr   = "10.10.0.0/24"

  workload_az_a = data.aws_availability_zones.available.names[0]
  workload_az_c = data.aws_availability_zones.available.names[1]
  egress_az_a   = data.aws_availability_zones.available.names[0]

  workload_subnets = {
    alb_public_a = {
      cidr = "10.10.1.0/27"
      az   = local.workload_az_a
    }
    alb_public_c = {
      cidr = "10.10.1.32/27"
      az   = local.workload_az_c
    }
    nfw_endpoint_a = {
      cidr = "10.10.1.64/28"
      az   = local.workload_az_a
    }
    nfw_endpoint_c = {
      cidr = "10.10.1.80/28"
      az   = local.workload_az_c
    }
    ec2_private_a = {
      cidr = "10.10.1.96/27"
      az   = local.workload_az_a
    }
    tgw_attachment_a = {
      cidr = "10.10.1.128/28"
      az   = local.workload_az_a
    }
  }

  egress_subnets = {
    tgw_attachment_a = {
      cidr = "10.10.0.0/28"
      az   = local.egress_az_a
    }
    nfw_endpoint_a = {
      cidr = "10.10.0.16/28"
      az   = local.egress_az_a
    }
    nat_public_a = {
      cidr = "10.10.0.32/28"
      az   = local.egress_az_a
    }
  }

  common_tags = {
    ManagedBy  = "Terraform"
    Project    = var.name_prefix
    Repository = "aws-examples/network/nfw-central-policy"
  }

  # Network Firewall endpoint IDs are derived from firewall status after creation.
  workload_firewall_endpoint_ids = {
    for sync_state in tolist(aws_networkfirewall_firewall.workload.firewall_status[0].sync_states) :
    sync_state.availability_zone => sync_state.attachment[0].endpoint_id
  }

  egress_firewall_endpoint_ids = {
    for sync_state in tolist(aws_networkfirewall_firewall.egress.firewall_status[0].sync_states) :
    sync_state.availability_zone => sync_state.attachment[0].endpoint_id
  }

  # Bootstrap the private EC2 instance only after the egress path is ready.
  nginx_user_data = <<-USERDATA
    #!/bin/bash
    set -euxo pipefail

    dnf -y update
    dnf -y install nginx

    cat > /usr/share/nginx/html/index.html <<'HTML'
    <h1>AWS NFW Demo - NGINX OK</h1>
    HTML

    systemctl enable nginx
    systemctl restart nginx
  USERDATA
}
