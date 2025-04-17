# Include config from root terragrunt.hcl

### Static part - not to be altered !!!!

include "root" {
  path = find_in_parent_folders()
}
# Set module source
terraform {
  source = "../../../../modules/app_lambda_functions"

  after_hook "init-lambda-sources" {
    commands     = ["init"]
    execute      = ["bash", "-c", "cp -r ${find_in_parent_folders("opt-ct-lambda")} ."]
    run_on_error = false
  }
}
# Set local vars from tfvars file
locals {
  common_tfvars = jsondecode(read_tfvars_file("../../common.tfvars"))
}

### ----------------------------------------------------


###  
### Dynamic part -- add values in the inputs - to mach lambda parameters
###

# Input values to use for the variables of the module
inputs = {

  # Lambda functions
  lambda_functions = {

    cognito_custom_message = {
      function_name = "test-cognito-custom-message"
      description   = "Test Cognito custom message"
      handler       = "index.handler"
      runtime       = "nodejs20.x"
      package_name  = "cognito_custom_message.zip"
    }
  }

}
