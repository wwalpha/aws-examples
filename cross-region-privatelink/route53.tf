# ----------------------------------------------------------------------------------------------
# AWS Route 53 Zone - Private Hosted Zone
# ----------------------------------------------------------------------------------------------
resource "aws_route53_zone" "private" {
  name = "test.internal"

  vpc {
    vpc_id = aws_vpc.main.id
  }

  tags = {
    Name = "${var.project_name}-phz"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route 53 Record - Test Record
# ----------------------------------------------------------------------------------------------
resource "aws_route53_record" "test" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "app.test.internal"
  type    = "A"
  ttl     = "300"
  records = ["10.0.0.100"] # Dummy IP for testing
}
