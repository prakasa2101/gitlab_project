# Include config from root terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

# Set module source
terraform {
  source = "../../../../modules/vpc"
}

# Set local vars from tfvars file
locals {
  common_tfvars = jsondecode(read_tfvars_file("../../common.tfvars"))
}

# Input values to use for the variables of the module
inputs = {
  environment      = local.common_tfvars.environment
  dns_name         = local.common_tfvars.dns_name
  vpc_cidr         = local.common_tfvars.vpc_cidr
  public_subnets   = local.common_tfvars.public_subnets
  private_subnets  = local.common_tfvars.private_subnets
  database_subnets = local.common_tfvars.database_subnets
  eks_cluster_name = local.common_tfvars.eks_cluster_name
}
