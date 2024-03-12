# --------------------------------------------------------------------------------------------------------------
# Amazon Cognito User Pool
# --------------------------------------------------------------------------------------------------------------
resource "aws_cognito_user_pool" "this" {
  name = "awslakeformationdata37684cf0_userpool_37684cf0-dev"

  auto_verified_attributes = ["email"]
  mfa_configuration        = "OFF"

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }
  }

  user_attribute_update_settings {
    attributes_require_verification_before_update = [
      "email",
    ]
  }

  username_configuration {
    case_sensitive = false
  }
}

# -------------------------------------------------------
# Amazon Cognito User Pool Client
# -------------------------------------------------------
resource "aws_cognito_user_pool_client" "web" {
  name = "awslak37684cf0_app_clientWeb"

  user_pool_id                         = aws_cognito_user_pool.this.id
  allowed_oauth_flows                  = []
  allowed_oauth_flows_user_pool_client = false
  allowed_oauth_scopes                 = []
  explicit_auth_flows                  = []

  token_validity_units {
    refresh_token = "days"
  }
}

# -------------------------------------------------------
# Amazon Cognito User Pool Client
# -------------------------------------------------------
resource "aws_cognito_user_pool_client" "this" {
  name = "awslak37684cf0_app_client"

  user_pool_id                         = aws_cognito_user_pool.this.id
  allowed_oauth_flows_user_pool_client = false

  token_validity_units {
    refresh_token = "days"
  }
}
#terraform import aws_cognito_identity_pool.this ap-northeast-1:c581f361-be38-4a10-877e-eea05494f8df
# --------------------------------------------------------------------------------------------------------------
# Amazon Cognito Identity Pool
# --------------------------------------------------------------------------------------------------------------
resource "aws_cognito_identity_pool" "this" {
  identity_pool_name = "awslakeformationdata37684cf0_identitypool_37684cf0__dev"

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.this.id
    provider_name           = aws_cognito_user_pool.this.endpoint
    server_side_token_check = false
  }

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.web.id
    provider_name           = aws_cognito_user_pool.this.endpoint
    server_side_token_check = false
  }
}

resource "aws_cognito_identity_pool_roles_attachment" "this" {
  identity_pool_id = aws_cognito_identity_pool.this.id

  roles = {
    "authenticated"   = "arn:aws:iam::334678299258:role/amplify-awslakeformationdata-dev-50937-authRole"
    "unauthenticated" = "arn:aws:iam::334678299258:role/amplify-awslakeformationdata-dev-50937-unauthRole"
  }
}
