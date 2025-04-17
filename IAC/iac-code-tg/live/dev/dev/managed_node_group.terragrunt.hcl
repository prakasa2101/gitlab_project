# Include config from root terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

# Set module source
terraform {
  source = "../../../../modules/managed_node_group"
}

# Set module dependencies
dependency "vpc" {
  config_path = "../../common/vpc"
}

dependency "eks" {
  config_path = "../eks"
}

# Set local vars from tfvars file
locals {
  common_tfvars = jsondecode(read_tfvars_file("../../common.tfvars"))
}

# Input values to use for the variables of the module
inputs = {
  environment                        = local.common_tfvars.environment
  project_name                       = local.common_tfvars.project_name
  eks_cluster_name                   = dependency.eks.outputs.eks_cluster_name
  eks_version                        = local.common_tfvars.eks_version
  private_subnets                    = dependency.vpc.outputs.private_subnets
  cluster_endpoint                   = dependency.eks.outputs.cluster_endpoint
  cluster_certificate_authority_data = dependency.eks.outputs.cluster_certificate_authority_data
  cluster_service_cidr               = dependency.eks.outputs.cluster_service_cidr
  node_security_group_id             = dependency.eks.outputs.node_security_group_id
  managed_node_group = {
    ami_id = local.common_tfvars.managed_node_group.ami_id
  }
}