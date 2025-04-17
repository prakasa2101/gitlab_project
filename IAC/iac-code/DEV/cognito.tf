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
}

resource "aws_cognito_user_pool_client" "appclient" {
  name = "opt-ct-${var.environment}-cognito-appclient"

  user_pool_id                  = aws_cognito_user_pool.userpool.id
  explicit_auth_flows           = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_USER_PASSWORD_AUTH"]
  prevent_user_existence_errors = "ENABLED"
}

resource "aws_cognito_user_group" "patients" {
  name         = "Patients"
  user_pool_id = aws_cognito_user_pool.userpool.id
}
