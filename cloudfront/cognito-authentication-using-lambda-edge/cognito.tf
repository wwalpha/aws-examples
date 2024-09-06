# --------------------------------------------------------------------------------------------------------------
# Amazon Cognito User Pool
# --------------------------------------------------------------------------------------------------------------
resource "aws_cognito_user_pool" "this" {
  deletion_protection = "INACTIVE"
  mfa_configuration   = "OFF"
  name                = "serverlessrepo-cloudfront-authorization-at-edge"
  username_attributes = ["email"]

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
    allow_admin_create_user_only = true
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }
}

# --------------------------------------------------------------------------------------------------------------
# Amazon Cognito User Pool Client
# --------------------------------------------------------------------------------------------------------------
resource "aws_cognito_user_pool_client" "this" {
  name                                          = "UserPoolClient-sb7is9be8FfU"
  allowed_oauth_flows                           = ["code"]
  allowed_oauth_flows_user_pool_client          = true
  allowed_oauth_scopes                          = ["aws.cognito.signin.user.admin", "email", "openid", "phone", "profile"]
  auth_session_validity                         = 3
  callback_urls                                 = ["https://d2la8734le0rgz.cloudfront.net/parseauth"]
  enable_propagate_additional_user_context_data = false
  enable_token_revocation                       = true
  logout_urls                                   = ["https://d2la8734le0rgz.cloudfront.net/"]
  prevent_user_existence_errors                 = "ENABLED"
  refresh_token_validity                        = 30
  supported_identity_providers                  = ["COGNITO"]
  user_pool_id                                  = aws_cognito_user_pool.this.id
}
