resource "aws_cognito_user_pool" "userpool" {
  name = "opt-ct-${var.environment}-cognito"

  mfa_configuration   = "OFF"
  username_attributes = ["email"]
  deletion_protection = "ACTIVE"

  auto_verified_attributes = ["email"]

  user_attribute_update_settings {
    attributes_require_verification_before_update = ["email"]
  }

  lambda_config {
    custom_message = module.cognito_custom_message.lambda_function_arn
  }

  schema {
    name                     = "passwordHistory"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = false
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  schema {
    name                     = "tidepool_id"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = false
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  schema {
    name                     = "tidepool_link_id"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = false
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

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

  # workaround for bug https://github.com/hashicorp/terraform-provider-aws/issues/35401
  username_configuration {
    case_sensitive = true
  }

  email_configuration {
    email_sending_account = "DEVELOPER"
    source_arn            = var.aws_ses_domain_identity_arn
    from_email_address    = "noreply@${var.aws_ses_domain}"
  }
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "opt-ct-${var.environment}"
  user_pool_id = aws_cognito_user_pool.userpool.id
}

resource "aws_cognito_user_pool_client" "opt-twist-appclient" {
  name = "opt-ct-${var.environment}-cognito-appclient"

  user_pool_id                  = aws_cognito_user_pool.userpool.id
  explicit_auth_flows           = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_USER_PASSWORD_AUTH"]
  prevent_user_existence_errors = "ENABLED"
  enable_token_revocation       = true
  # generate_secret               = true

  access_token_validity  = 60
  id_token_validity      = 60
  refresh_token_validity = 30
  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
}

resource "aws_cognito_user_pool_client" "opt-ct-tidepool-appclient" {
  name = "opt-ct-${var.environment}-cognito-tidepool-appclient"

  user_pool_id                  = aws_cognito_user_pool.userpool.id
  explicit_auth_flows           = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_ADMIN_USER_PASSWORD_AUTH"]
  prevent_user_existence_errors = "ENABLED"
  enable_token_revocation       = true
  generate_secret               = true
  callback_urls                 = ["https://dev-nginx.dev-ecs.myctportal.com/tidepool/callback"]
  logout_urls                   = ["http://localhost:3002/tidepool/signout"]
  supported_identity_providers  = ["COGNITO"]
  allowed_oauth_flows           = ["code"]
  allowed_oauth_scopes          = ["email", "openid", "phone"]

  enable_propagate_additional_user_context_data = true

  access_token_validity  = 60
  id_token_validity      = 60
  refresh_token_validity = 30
  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
}

resource "aws_cognito_user_pool_client" "opt-twist-pwd-appclient" {
  name = "opt-ct-${var.environment}-cognito-pwd-appclient"

  user_pool_id                  = aws_cognito_user_pool.userpool.id
  explicit_auth_flows           = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_USER_PASSWORD_AUTH"]
  prevent_user_existence_errors = "ENABLED"
  enable_token_revocation       = true
  generate_secret               = true

  access_token_validity  = 60
  id_token_validity      = 60
  refresh_token_validity = 30
  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
}

resource "aws_cognito_user_pool_client" "opt-twist-follower-appclient" {
  name = "opt-ct-${var.environment}-cognito-follower-appclient"

  user_pool_id                  = aws_cognito_user_pool.userpool.id
  explicit_auth_flows           = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_USER_PASSWORD_AUTH"]
  prevent_user_existence_errors = "ENABLED"
  enable_token_revocation       = true
  generate_secret               = true

  access_token_validity  = 60
  id_token_validity      = 60
  refresh_token_validity = 30
  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
}

resource "aws_cognito_user_group" "patients" {
  name         = "Patients"
  user_pool_id = aws_cognito_user_pool.userpool.id
}
