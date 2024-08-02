# ----------------------------------------------------------------------------------------------
# Cloudfront Origin Access Control
# ----------------------------------------------------------------------------------------------
resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${local.prefix}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# ----------------------------------------------------------------------------------------------
# Cloudfront Distribution
# ----------------------------------------------------------------------------------------------
resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name              = aws_s3_bucket.this.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
    origin_id                = "myS3Origin"
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", ]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "myS3Origin"
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.this.arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# ----------------------------------------------------------------------------------------------
# Cloudfront Function
# ----------------------------------------------------------------------------------------------
resource "aws_cloudfront_function" "this" {
  name    = "${local.prefix}-function"
  runtime = "cloudfront-js-2.0"
  publish = true
  code    = <<EOF
function handler(event) {

  var request = event.request;
  var headers = request.headers;

  // echo -n user:pass | base64
  var authString = "Basic ZHhjOmR4YzIwMjQwODAx";

  if (
    typeof headers.authorization === "undefined" ||
    headers.authorization.value !== authString
  ) {
    return {
      statusCode: 401,
      statusDescription: "Unauthorized",
      headers: { "www-authenticate": { value: "Basic" } }
    };
  }

  return request;
}
EOF
}
