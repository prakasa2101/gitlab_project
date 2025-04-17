# Include config from root terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

# Set module source
terraform {
  source = "../../../../modules/aurora"
}

# Set module dependencies
dependency "vpc" {
  config_path = "../../common/vpc"
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
  environment  = local.common_tfvars.environment
  project_name = local.common_tfvars.project_name

  # Aurora base values
  aurora_instance_class = local.common_tfvars.aurora_instance_class
  aurora_is_serverless  = local.common_tfvars.aurora_is_serverless
  aurora_engine         = local.common_tfvars.aurora_engine

  s3_state_bucket = local.common_tfvars.s3_state_bucket

  # Network
  vpc_id                      = dependency.vpc.outputs.vpc_id
  database_subnet_group_name  = dependency.vpc.outputs.database_subnet_group_name
  database_subnets            = dependency.vpc.outputs.database_subnets
  private_subnets_cidr_blocks = dependency.vpc.outputs.private_subnets_cidr_blocks

  # Encryption
  kms_keys = dependency.kms.outputs.kms_keys
  kms_path = "common/kms/terraform.tfstate"


  # Map of aurora Cluster to be created... 
  # To change list of deployed Clusters add/remove objects in below map.
  aurora_clusters = {
    opt-ct = {
      aurora_cluster_name                 = "${local.common_tfvars.project_name}-${local.common_tfvars.environment}",
      iam_database_authentication_enabled = true
    }
    opt-ct-reporting = {
      aurora_cluster_name                 = "${local.common_tfvars.project_name}-reporting-${local.common_tfvars.environment}",
      iam_database_authentication_enabled = true
    }
  }

}
