##############################
#API Gateway
##############################

output "api-gw-login-arn" {
  description = "The ARN of the Login API gateway"
  value       = aws_apigatewayv2_api.api-gw-login.arn
}

output "api-gw-accounts-arn" {
  description = "The ARN of the Login API gateway"
  value       = aws_apigatewayv2_api.api-gw-accounts.arn
}



