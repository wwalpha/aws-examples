# ----------------------------------------------------------------------------------------------
# Route53 Hosted Zone - Workload App1
# ----------------------------------------------------------------------------------------------
resource "aws_route53_zone" "app1" {
  name          = "app1.${var.aws_domain_name}"
  force_destroy = true

  vpc {
    vpc_id = var.vpc_id_central_dns
  }
}

# ----------------------------------------------------------------------------------------------
# Route53 Record - ALB
# ----------------------------------------------------------------------------------------------
resource "aws_route53_record" "alb_app1" {
  allow_overwrite = true
  zone_id         = aws_route53_zone.app1.zone_id
  name            = "alb.${aws_route53_zone.app1.name}"
  type            = "A"

  alias {
    name                   = var.alb_dns_name_app1
    zone_id                = var.alb_zone_id_app1
    evaluate_target_health = true
  }
}

# ----------------------------------------------------------------------------------------------
# Route53 Hosted Zone - Workload App2
# ----------------------------------------------------------------------------------------------
resource "aws_route53_zone" "app2" {
  depends_on    = [aws_route53_zone.app1]
  name          = "app2.${var.aws_domain_name}"
  force_destroy = true

  vpc {
    vpc_id = var.vpc_id_central_dns
  }
}


# ----------------------------------------------------------------------------------------------
# Route53 Record - Workload App2 ALB
# ----------------------------------------------------------------------------------------------
resource "aws_route53_record" "alb_app2" {
  allow_overwrite = true
  zone_id         = aws_route53_zone.app2.zone_id
  name            = "alb.${aws_route53_zone.app2.name}"
  type            = "A"

  alias {
    name                   = var.alb_dns_name_app2
    zone_id                = var.alb_zone_id_app2
    evaluate_target_health = true
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route53 Profile Associate Resource to Profile
# ----------------------------------------------------------------------------------------------
resource "null_resource" "route53_profile_associate_resource" {
  triggers = {
    RESOURCE_ID_HOSTED_ZONE1    = aws_route53_zone.app1.zone_id
    RESOURCE_ID_HOSTED_ZONE2    = aws_route53_zone.app1.zone_id
    RESOURCE_ID_RESOLVER_RULE1  = data.aws_route53_resolver_rule.forward_onpremise.id
    RESOURCE_ID_RESOLVER_RULE2  = data.aws_route53_resolver_rule.forward_ssm_endpoint.id
    RESOURCE_ARN_HOSTED_ZONE1   = aws_route53_zone.app1.arn
    RESOURCE_ARN_HOSTED_ZONE2   = aws_route53_zone.app2.arn
    RESOURCE_ARN_RESOLVER_RULE1 = data.aws_route53_resolver_rule.forward_onpremise.arn
    RESOURCE_ARN_RESOLVER_RULE2 = data.aws_route53_resolver_rule.forward_ssm_endpoint.arn
  }

  provisioner "local-exec" {
    command = "sh ${path.module}/scripts/associateResourceToProfile.sh"

    environment = {
      RESOURCE_ID_HOSTED_ZONE1    = self.triggers.RESOURCE_ID_HOSTED_ZONE1
      RESOURCE_ID_HOSTED_ZONE2    = self.triggers.RESOURCE_ID_HOSTED_ZONE2
      RESOURCE_ID_RESOLVER_RULE1  = self.triggers.RESOURCE_ID_RESOLVER_RULE1
      RESOURCE_ID_RESOLVER_RULE2  = self.triggers.RESOURCE_ID_RESOLVER_RULE2
      RESOURCE_ARN_HOSTED_ZONE1   = self.triggers.RESOURCE_ARN_HOSTED_ZONE1
      RESOURCE_ARN_HOSTED_ZONE2   = self.triggers.RESOURCE_ARN_HOSTED_ZONE2
      RESOURCE_ARN_RESOLVER_RULE1 = self.triggers.RESOURCE_ARN_RESOLVER_RULE1
      RESOURCE_ARN_RESOLVER_RULE2 = self.triggers.RESOURCE_ARN_RESOLVER_RULE2
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "sh ${path.module}/scripts/disassociateResourceToProfile.sh"

    environment = {
      RESOURCE_ARN_HOSTED_ZONE1   = self.triggers.RESOURCE_ARN_HOSTED_ZONE1
      RESOURCE_ARN_HOSTED_ZONE2   = self.triggers.RESOURCE_ARN_HOSTED_ZONE2
      RESOURCE_ARN_RESOLVER_RULE1 = self.triggers.RESOURCE_ARN_RESOLVER_RULE1
      RESOURCE_ARN_RESOLVER_RULE2 = self.triggers.RESOURCE_ARN_RESOLVER_RULE2
    }
  }
}

