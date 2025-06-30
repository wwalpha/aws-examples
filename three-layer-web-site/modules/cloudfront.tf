# ------------------------------------------------------------------------------------------------
# AWS CloudFront Distribution
# ------------------------------------------------------------------------------------------------
resource "aws_cloudfront_distribution" "this" {
  enabled    = true
  comment    = var.env_name
  web_acl_id = var.web_acl_id

  origin {
    domain_name = aws_lb.proxy.dns_name
    origin_id   = aws_lb.proxy.dns_name

    custom_header {
      name  = "x-shared-key"
      value = var.shared_key
    }

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = lookup(local.origin_read_timeout, var.env_name)
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_lb.proxy.dns_name
    compress               = false
    viewer_protocol_policy = "redirect-to-https"
    # cache_policy_id          = "e16abe25-d7bc-438b-b608-2384caf4935f"
    # origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"

    forwarded_values {
      headers                 = ["*"]
      query_string            = true
      query_string_cache_keys = []
      cookies {
        forward           = "all"
        whitelisted_names = []
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

}
