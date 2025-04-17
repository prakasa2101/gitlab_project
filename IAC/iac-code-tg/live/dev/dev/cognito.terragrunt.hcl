# Include config from root terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

# Set module source
terraform {
  source = "../../../../modules/cognito"
}

# Set module dependencies
dependency "ses" {
  config_path = "../../common/ses"
}

# Set local vars from tfvars file
locals {
  common_tfvars = jsondecode(read_tfvars_file("../../common.tfvars"))
}

# Input values to use for the variables of the module
inputs = {
  environment                 = local.common_tfvars.environment
  s3_state_bucket             = local.common_tfvars.s3_state_bucket
  aws_ses_domain_identity_arn = dependency.ses.outputs.aws_ses_domain_identity_arn
  aws_ses_domain              = dependency.ses.outputs.aws_ses_domain
}
