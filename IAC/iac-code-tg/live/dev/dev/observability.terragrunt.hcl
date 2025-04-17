# Include config from root terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

# Set module source
terraform {
  source = "../../../../modules/observability"
}

# Set module dependencies
dependency "eks" {
  config_path = "../eks"
}

dependency "kms" {
  config_path = "../../common/kms"
}

# Set local vars from tfvars file
locals {
  common_tfvars = jsondecode(read_tfvars_file("../../common.tfvars"))
}

# Input values to use for the variables of the module
inputs = {
  eks_cluster_name = dependency.eks.outputs.eks_cluster_name
  kms_key_id       = dependency.kms.outputs.kms_keys["cloudwatch-logs"].arn
  environment      = local.common_tfvars.environment
  project_name     = local.common_tfvars.project_name
}