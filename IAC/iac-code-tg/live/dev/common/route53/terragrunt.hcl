# Include config from root terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

# Set module source
terraform {
  source = "../../../../modules/route53"
}

# Set local vars from tfvars file
locals {
  common_tfvars = jsondecode(read_tfvars_file("../../common.tfvars"))
}

# Input values to use for the variables of the module
inputs = {
  dns_name = local.common_tfvars.dns_name
}
