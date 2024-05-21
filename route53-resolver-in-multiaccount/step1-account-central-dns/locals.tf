locals {
  vpc_cidr_block_cloud = "10.0.0.0/8"

  iam_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "*",
        "Resource" : "*"
      }
    ]
  })

  route53_profile_name = "${var.prefix}-Profile"
}
