# ----------------------------------------------------------------------------------------------
# Router Instance Security Group for OnPremiseA
# ----------------------------------------------------------------------------------------------
module "router_sg_onpremise_a" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_router_sg_onpremise_a"
  vpc_id = var.vpc_id_onpremise_a
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
# Router Instance Security Group for OnPremiseA
# ----------------------------------------------------------------------------------------------
module "router_sg_onpremise_b" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_router_sg_onpremise_b"
  vpc_id = var.vpc_id_onpremise_b
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
module "nlb_sg_relay_a" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_nlb_sg_relay_a"
  vpc_id = var.vpc_id_aws_relay_a
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
module "proxy_sg_relay_a" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_proxy_sg_relay_a"
  vpc_id = var.vpc_id_aws_relay_a
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
module "nlb_sg_relay_b" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_nlb_sg_relay_b"
  vpc_id = var.vpc_id_aws_relay_b
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
module "proxy_sg_relay_b" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}_proxy_sg_relay_b"
  vpc_id = var.vpc_id_aws_relay_b
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
