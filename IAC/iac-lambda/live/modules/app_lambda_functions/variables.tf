variable "lambda_functions" {
  type = map(object({
    function_name = string
    description   = string
    handler       = string
    runtime       = string
    package_name  = string
  }))
}