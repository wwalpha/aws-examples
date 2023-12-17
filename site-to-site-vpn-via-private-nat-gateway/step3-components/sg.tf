# ----------------------------------------------------------------------------------------------
# Router Instance Security Group for OnPremiseEU
# ----------------------------------------------------------------------------------------------
module "router_sg_onpremise_eu" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_router_sg_onpremise_eu"
  vpc_id = var.vpc_id_onpremise_eu
  ingress_with_cidr_blocks = [
    {
      rule        = "all-icmp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
  }]
}

# ----------------------------------------------------------------------------------------------
# Router Instance Security Group for OnPremiseEU
# ----------------------------------------------------------------------------------------------
module "router_sg_onpremise_us" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_router_sg_onpremise_us"
  vpc_id = var.vpc_id_onpremise_us
  ingress_with_cidr_blocks = [
    {
      rule        = "all-icmp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
  }]
}

# ----------------------------------------------------------------------------------------------
# NLB Security Group for Relay A
# ----------------------------------------------------------------------------------------------
module "nlb_sg_relay_eu" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_nlb_sg_relay_eu"
  vpc_id = var.vpc_id_aws_relay_eu
  ingress_with_cidr_blocks = [
    {
      rule        = "all-icmp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
  }]
}

# ----------------------------------------------------------------------------------------------
# Proxy Security Group for Relay A
# ----------------------------------------------------------------------------------------------
module "proxy_sg_relay_eu" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_proxy_sg_relay_eu"
  vpc_id = var.vpc_id_aws_relay_eu
  ingress_with_cidr_blocks = [
    {
      rule        = "all-icmp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
  }]
}

# ----------------------------------------------------------------------------------------------
# NLB Security Group for Relay B
# ----------------------------------------------------------------------------------------------
module "nlb_sg_relay_us" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_nlb_sg_relay_us"
  vpc_id = var.vpc_id_aws_relay_us
  ingress_with_cidr_blocks = [
    {
      rule        = "all-icmp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
  }]
}

# ----------------------------------------------------------------------------------------------
# Proxy Security Group for Relay B
# ----------------------------------------------------------------------------------------------
module "proxy_sg_relay_us" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_proxy_sg_relay_us"
  vpc_id = var.vpc_id_aws_relay_us
  ingress_with_cidr_blocks = [
    {
      rule        = "all-icmp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
  }]
}

# ----------------------------------------------------------------------------------------------
# AWS NGINX Security Group
# ----------------------------------------------------------------------------------------------
module "nginx_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_nginx_sg"
  vpc_id = var.vpc_id_aws_app
  ingress_with_cidr_blocks = [
    {
      rule        = "all-icmp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
  }]
}
