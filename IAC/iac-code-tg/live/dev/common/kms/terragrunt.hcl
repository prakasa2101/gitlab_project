# Include config from root terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

# Set module source
terraform {
  source = "../../../../modules/kms"
}

# Set local vars from tfvars file
locals {
  common_tfvars = jsondecode(read_tfvars_file("../../common.tfvars"))
}

# Input values to use for the variables of the module
inputs = {
  kms_keys            = local.common_tfvars.kms_keys
  administrator_roles = local.common_tfvars.administrator_roles
  region              = local.common_tfvars.region
}
