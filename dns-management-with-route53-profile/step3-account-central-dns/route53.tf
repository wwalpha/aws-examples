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
