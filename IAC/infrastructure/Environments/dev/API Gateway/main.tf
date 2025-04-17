terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
backend "s3" {
  bucket         = "opt-ct-tf-state"
  key            = "account/environments/dev/api-gateway-terraform.tfstate"
  region         = "us-east-1"        
  encrypt        = true
  dynamodb_table = "opt-ct-tf-state-store"
  }
}

provider "aws" {
  region = var.region
}

data "terraform_remote_state" "previous_state" {
  backend = "s3"
  config = {
    bucket         = var.bucketname
    key            = var.ecstfpath 
    region         = var.region
  }
}

resource "aws_apigatewayv2_api" "api-gw-login" {
  name          = "${var.project}-${var.app}-${var.env}-${var.microservice1}"
  protocol_type = "HTTP"
  tags = {
    Terraform = "true"
    Environment = var.env
  }
}

resource "aws_apigatewayv2_integration" "forgot-password" {
  api_id           = aws_apigatewayv2_api.api-gw-login.id
  integration_type = "HTTP_PROXY"

  integration_method = "POST"
  integration_uri    = "https://${data.terraform_remote_state.previous_state.outputs.lb-dns}/forgot-password"
  depends_on = [aws_apigatewayv2_api.api-gw-login]
}

resource "aws_apigatewayv2_route" "forgot-password-route" {
  api_id    = aws_apigatewayv2_api.api-gw-login.id
  route_key = "POST /forgot-password"

  target = "integrations/${aws_apigatewayv2_integration.forgot-password.id}"
  depends_on = [aws_apigatewayv2_api.api-gw-login]
}

resource "aws_apigatewayv2_integration" "get-stepdata" {
  api_id           = aws_apigatewayv2_api.api-gw-login.id
  integration_type = "HTTP_PROXY"

  integration_method = "POST"
  integration_uri    = "https://${data.terraform_remote_state.previous_state.outputs.lb-dns}/get-stepdata"
  depends_on = [aws_apigatewayv2_api.api-gw-login]
}

resource "aws_apigatewayv2_route" "get-stepdata-route" {
  api_id    = aws_apigatewayv2_api.api-gw-login.id
  route_key = "POST /get-stepdata"

  target = "integrations/${aws_apigatewayv2_integration.get-stepdata.id}"
  depends_on = [aws_apigatewayv2_api.api-gw-login]
}

resource "aws_apigatewayv2_integration" "login" {
  api_id           = aws_apigatewayv2_api.api-gw-login.id
  integration_type = "HTTP_PROXY"

  integration_method = "POST"
  integration_uri    = "https://${data.terraform_remote_state.previous_state.outputs.lb-dns}/login"
  depends_on = [aws_apigatewayv2_api.api-gw-login]
}

resource "aws_apigatewayv2_route" "login-route" {
  api_id    = aws_apigatewayv2_api.api-gw-login.id
  route_key = "POST /login"

  target = "integrations/${aws_apigatewayv2_integration.login.id}"
  depends_on = [aws_apigatewayv2_api.api-gw-login]
}

resource "aws_apigatewayv2_integration" "reset-password" {
  api_id           = aws_apigatewayv2_api.api-gw-login.id
  integration_type = "HTTP_PROXY"

  integration_method = "POST"
  integration_uri    = "https://${data.terraform_remote_state.previous_state.outputs.lb-dns}/reset-password"
  depends_on = [aws_apigatewayv2_api.api-gw-login]
}

resource "aws_apigatewayv2_route" "reset-password-route" {
  api_id    = aws_apigatewayv2_api.api-gw-login.id
  route_key = "POST /reset-password"

  target = "integrations/${aws_apigatewayv2_integration.reset-password.id}"
  depends_on = [aws_apigatewayv2_api.api-gw-login]
}

resource "aws_apigatewayv2_integration" "save-stepone" {
  api_id           = aws_apigatewayv2_api.api-gw-login.id
  integration_type = "HTTP_PROXY"

  integration_method = "POST"
  integration_uri    = "https://${data.terraform_remote_state.previous_state.outputs.lb-dns}/save-stepone"
  depends_on = [aws_apigatewayv2_api.api-gw-login]
}

resource "aws_apigatewayv2_route" "save-stepone-route" {
  api_id    = aws_apigatewayv2_api.api-gw-login.id
  route_key = "POST /save-stepone"

  target = "integrations/${aws_apigatewayv2_integration.save-stepone.id}"
  depends_on = [aws_apigatewayv2_api.api-gw-login]
}

resource "aws_apigatewayv2_integration" "prescriber" {
  api_id           = aws_apigatewayv2_api.api-gw-login.id
  integration_type = "HTTP_PROXY"

  integration_method = "POST"
  integration_uri    = "https://${data.terraform_remote_state.previous_state.outputs.lb-dns}/prescriber"
  depends_on = [aws_apigatewayv2_api.api-gw-login]
}

resource "aws_apigatewayv2_route" "prescriber-route" {
  api_id    = aws_apigatewayv2_api.api-gw-login.id
  route_key = "POST /prescriber"

  target = "integrations/${aws_apigatewayv2_integration.prescriber.id}"
  depends_on = [aws_apigatewayv2_api.api-gw-login]
}

resource "aws_apigatewayv2_integration" "account-details-email" {
  api_id           = aws_apigatewayv2_api.api-gw-login.id
  integration_type = "HTTP_PROXY"

  integration_method = "POST"
  integration_uri    = "https://${data.terraform_remote_state.previous_state.outputs.lb-dns}/account-details/{email}"
  depends_on = [aws_apigatewayv2_api.api-gw-login]
}

resource "aws_apigatewayv2_route" "verify-route" {
  api_id    = aws_apigatewayv2_api.api-gw-login.id
  route_key = "POST /account-details/{email}"

  target = "integrations/${aws_apigatewayv2_integration.account-details-email.id}"
  depends_on = [aws_apigatewayv2_api.api-gw-login]
}

resource "aws_apigatewayv2_integration" "patient-update-userId" {
  api_id           = aws_apigatewayv2_api.api-gw-login.id
  integration_type = "HTTP_PROXY"

  integration_method = "POST"
  integration_uri    = "https://${data.terraform_remote_state.previous_state.outputs.lb-dns}/patient-update/{userId}"
  depends_on = [aws_apigatewayv2_api.api-gw-login]
}

resource "aws_apigatewayv2_route" "patient-update-userId-route" {
  api_id    = aws_apigatewayv2_api.api-gw-login.id
  route_key = "POST /patient-update/{userId}"

  target = "integrations/${aws_apigatewayv2_integration.patient-update-userId.id}"
  depends_on = [aws_apigatewayv2_api.api-gw-login]
}

resource "aws_apigatewayv2_api" "api-gw-accounts" {
  name          = "${var.project}-${var.app}-${var.env}-${var.microservice2}"
  protocol_type = "HTTP"
  tags = {
    Terraform = "true"
    Environment = var.env
  }
}

resource "aws_apigatewayv2_integration" "accounts" {
  api_id           = aws_apigatewayv2_api.api-gw-accounts.id
  integration_type = "HTTP_PROXY"

  integration_method = "POST"
  integration_uri    = "https://${data.terraform_remote_state.previous_state.outputs.lb-dns}/accounts"
  depends_on = [aws_apigatewayv2_api.api-gw-accounts]
}

resource "aws_apigatewayv2_route" "accounts-route" {
  api_id    = aws_apigatewayv2_api.api-gw-accounts.id
  route_key = "POST /accounts"

  target = "integrations/${aws_apigatewayv2_integration.accounts.id}"
  depends_on = [aws_apigatewayv2_api.api-gw-accounts]
}

resource "aws_apigatewayv2_integration" "accounts-authenticate" {
  api_id           = aws_apigatewayv2_api.api-gw-accounts.id
  integration_type = "HTTP_PROXY"

  integration_method = "POST"
  integration_uri    = "https://${data.terraform_remote_state.previous_state.outputs.lb-dns}/accounts/authenticate"
  depends_on = [aws_apigatewayv2_api.api-gw-accounts]
}

resource "aws_apigatewayv2_route" "accounts-authenticate-route" {
  api_id    = aws_apigatewayv2_api.api-gw-accounts.id
  route_key = "POST /accounts/authenticate"

  target = "integrations/${aws_apigatewayv2_integration.accounts-authenticate.id}"
  depends_on = [aws_apigatewayv2_api.api-gw-accounts]
}

resource "aws_apigatewayv2_integration" "accounts-reset-password" {
  api_id           = aws_apigatewayv2_api.api-gw-accounts.id
  integration_type = "HTTP_PROXY"

  integration_method = "POST"
  integration_uri    = "https://${data.terraform_remote_state.previous_state.outputs.lb-dns}/accounts/reset-password"
  depends_on = [aws_apigatewayv2_api.api-gw-accounts]
}

resource "aws_apigatewayv2_route" "accounts-reset-password-route" {
  api_id    = aws_apigatewayv2_api.api-gw-accounts.id
  route_key = "POST /accounts/reset-password"

  target = "integrations/${aws_apigatewayv2_integration.accounts-reset-password.id}"
  depends_on = [aws_apigatewayv2_api.api-gw-accounts]
}

resource "aws_apigatewayv2_integration" "accounts-forgot-password" {
  api_id           = aws_apigatewayv2_api.api-gw-accounts.id
  integration_type = "HTTP_PROXY"

  integration_method = "POST"
  integration_uri    = "https://${data.terraform_remote_state.previous_state.outputs.lb-dns}/accounts/forgot-password"
  depends_on = [aws_apigatewayv2_api.api-gw-accounts]
}

resource "aws_apigatewayv2_route" "accounts-forgot-password-route" {
  api_id    = aws_apigatewayv2_api.api-gw-accounts.id
  route_key = "POST /accounts/forgot-password"

  target = "integrations/${aws_apigatewayv2_integration.accounts-forgot-password.id}"
  depends_on = [aws_apigatewayv2_api.api-gw-accounts]
}

resource "aws_apigatewayv2_integration" "accounts-verify" {
  api_id           = aws_apigatewayv2_api.api-gw-accounts.id
  integration_type = "HTTP_PROXY"

  integration_method = "POST"
  integration_uri    = "https://${data.terraform_remote_state.previous_state.outputs.lb-dns}/accounts/verify"
  depends_on = [aws_apigatewayv2_api.api-gw-accounts]
}

resource "aws_apigatewayv2_route" "accounts-verify-route" {
  api_id    = aws_apigatewayv2_api.api-gw-accounts.id
  route_key = "POST /accounts/verify"

  target = "integrations/${aws_apigatewayv2_integration.accounts-verify.id}"
  depends_on = [aws_apigatewayv2_api.api-gw-accounts]
}