module "lambda" {
  source = "terraform-aws-modules/lambda/aws"

  for_each = var.lambda_functions

  function_name = each.value.function_name
  description   = each.value.description
  handler       = each.value.handler
  runtime       = each.value.runtime

  create_package         = false
  local_existing_package = "opt-ct-lambda/${each.key}/${each.value.package_name}"

  ignore_source_code_hash = true
}

