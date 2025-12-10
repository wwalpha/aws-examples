# ----------------------------------------------------------------------------------------------
# Transfer Family - Web App (via AWSCC)
# ----------------------------------------------------------------------------------------------
resource "awscc_transfer_web_app" "this" {
  identity_provider_details = {
    instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
    role         = aws_iam_role.webapp.arn
  }
  web_app_units = {
    provisioned = 1
  }
  tags = [
    {
      key   = "Name"
      value = "${local.name_prefix}-webapp"
    },
    {
      key   = "Project"
      value = "transfer-webapp-demo"
    },
    {
      key   = "ManagedBy"
      value = "Terraform"
    }
  ]
}

# ----------------------------------------------------------------------------------------------
# S3 Access Grants - Instance
# ----------------------------------------------------------------------------------------------
resource "aws_s3control_access_grants_instance" "this" {
  account_id          = data.aws_caller_identity.current.account_id
  identity_center_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  tags                = local.tags
}

# ----------------------------------------------------------------------------------------------
# S3 Access Grants - Location
# ----------------------------------------------------------------------------------------------
resource "aws_s3control_access_grants_location" "this" {
  account_id     = data.aws_caller_identity.current.account_id
  iam_role_arn   = aws_iam_role.s3_access_grants.arn
  location_scope = "s3://${aws_s3_bucket.transfer.bucket}"
  tags           = local.tags

  depends_on = [aws_s3control_access_grants_instance.this]
}

# ----------------------------------------------------------------------------------------------
# Identity Center - User
# ----------------------------------------------------------------------------------------------
resource "aws_identitystore_user" "this" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  display_name = "${var.user_given_name} ${var.user_family_name}"
  user_name    = var.user_name

  name {
    given_name  = var.user_given_name
    family_name = var.user_family_name
  }

  emails {
    value = var.user_email
  }
}

# ----------------------------------------------------------------------------------------------
# Identity Center - Group Membership
# ----------------------------------------------------------------------------------------------
resource "aws_identitystore_group_membership" "this" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  group_id          = data.aws_identitystore_group.this.group_id
  member_id         = aws_identitystore_user.this.user_id
}

# ----------------------------------------------------------------------------------------------
# S3 Access Grant
# ----------------------------------------------------------------------------------------------
resource "aws_s3control_access_grant" "this" {
  account_id                = data.aws_caller_identity.current.account_id
  access_grants_location_id = aws_s3control_access_grants_location.this.access_grants_location_id
  permission                = "READWRITE"

  grantee {
    grantee_type       = "DIRECTORY_GROUP"
    grantee_identifier = data.aws_identitystore_group.this.group_id
  }

  access_grants_location_configuration {
    s3_sub_prefix = "*"
  }

  tags = local.tags
}

# ----------------------------------------------------------------------------------------------
# S3 - Transfer Bucket
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "transfer" {
  bucket        = "${local.name_prefix}-transfer-bucket-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
  tags          = local.tags
}

# ----------------------------------------------------------------------------------------------
# S3 - Dummy Object
# ----------------------------------------------------------------------------------------------
resource "aws_s3_object" "dummy" {
  bucket = aws_s3_bucket.transfer.id
  key    = "dummy.txt"
  source = "${path.module}/files/dummy.txt"
  etag   = filemd5("${path.module}/files/dummy.txt")
  tags   = local.tags
}

# ----------------------------------------------------------------------------------------------
# S3 - CORS Configuration
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket_cors_configuration" "transfer" {
  bucket = aws_s3_bucket.transfer.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
    allowed_origins = ["https://*.transfer-webapp.ap-northeast-1.on.aws"]
    expose_headers  = ["ETag", "x-amz-server-side-encryption", "x-amz-request-id", "x-amz-id-2"]
    max_age_seconds = 3000
  }
}

# ----------------------------------------------------------------------------------------------
# S3 - Transfer Bucket 2
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "transfer_2" {
  bucket        = "${local.name_prefix}-transfer-bucket-2-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
  tags          = local.tags
}

# ----------------------------------------------------------------------------------------------
# S3 - Dummy Object 2
# ----------------------------------------------------------------------------------------------
resource "aws_s3_object" "dummy_2" {
  bucket = aws_s3_bucket.transfer_2.id
  key    = "dummy2.txt"
  source = "${path.module}/files/dummy.txt"
  etag   = filemd5("${path.module}/files/dummy.txt")
  tags   = local.tags
}

# ----------------------------------------------------------------------------------------------
# S3 - CORS Configuration 2
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket_cors_configuration" "transfer_2" {
  bucket = aws_s3_bucket.transfer_2.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
    allowed_origins = ["https://*.transfer-webapp.ap-northeast-1.on.aws"]
    expose_headers  = ["ETag", "x-amz-server-side-encryption", "x-amz-request-id", "x-amz-id-2"]
    max_age_seconds = 3000
  }
}

# ----------------------------------------------------------------------------------------------
# S3 Access Grants - Location 2
# ----------------------------------------------------------------------------------------------
resource "aws_s3control_access_grants_location" "this_2" {
  account_id     = data.aws_caller_identity.current.account_id
  iam_role_arn   = aws_iam_role.s3_access_grants.arn
  location_scope = "s3://${aws_s3_bucket.transfer_2.bucket}"
  tags           = local.tags

  depends_on = [aws_s3control_access_grants_instance.this]
}

# ----------------------------------------------------------------------------------------------
# S3 Access Grant 2
# ----------------------------------------------------------------------------------------------
resource "aws_s3control_access_grant" "this_2" {
  account_id                = data.aws_caller_identity.current.account_id
  access_grants_location_id = aws_s3control_access_grants_location.this_2.access_grants_location_id
  permission                = "READWRITE"

  grantee {
    grantee_type       = "DIRECTORY_GROUP"
    grantee_identifier = data.aws_identitystore_group.this.group_id
  }

  access_grants_location_configuration {
    s3_sub_prefix = "*"
  }

  tags = local.tags
}
