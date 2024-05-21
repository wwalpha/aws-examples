locals {
  az_suffix            = [for az in var.availability_zones : split("-", az)[2]]
  vpc_cidr_block_cloud = "10.0.0.0/8"
  vpc_cidr_block_any   = "0.0.0.0/0"

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
}
