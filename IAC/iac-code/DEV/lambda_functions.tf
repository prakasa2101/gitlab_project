module "cognito_custom_message" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "cognito-custom-message"
  description   = "Cognito custom message"
  handler       = "index.handler"
  runtime       = "nodejs20.x"

  create_package         = false
  local_existing_package = "./lambda_functions/cognito_custom_message.zip"

  ignore_source_code_hash = true
}
