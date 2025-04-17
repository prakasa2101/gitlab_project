# Include config from root terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

# Set module source
terraform {
  source = "../../../../modules/iam"
}

# Set module dependencies
dependency "eks" {
  config_path = "../eks"
}

dependency "aurora" {
  config_path = "../aurora"
}

dependency "cognito" {
  config_path = "../cognito"
}

# Set local vars from tfvars file
locals {
  common_tfvars = jsondecode(read_tfvars_file("../../common.tfvars"))
}

# Input values to use for the variables of the module
inputs = {
  aws_account                 = local.common_tfvars.aws_account
  s3_state_bucket             = local.common_tfvars.s3_state_bucket
  eks_cluster_name            = dependency.eks.outputs.eks_cluster_name
  cluster_oidc_issuer_url     = dependency.eks.outputs.cluster_oidc_issuer_url
  aurora_cluster_resource_ids = dependency.aurora.outputs.cluster_resource_ids
  cognito_user_pool_id        = dependency.cognito.outputs.user_pool_id


  identity_providers = [
    "aws-client-vpn",
    "aws-client-vpn-self-service"
  ]


  ### POD Identity mappings

  # Access to RDS:  "opt-ct/postgres"
  opt_twist_rds_pod_identity_associations = {
    rds-access-ct-portal-backend = {
      namespace       = "ct-portal-backend",
      service_account = "rds-access-ct-portal-backend-sa"
    }
    rds-access-ct-portal-data-etl = {
      namespace       = "ct-portal-data-etl",
      service_account = "rds-access-ct-portal-data-etl-sa"
    }
    rds-access-example = {
      namespace       = "opt-sandbox",
      service_account = "rds-access-example"
    }
  }

  # Access to RDS:  "opt-ct-reporting/postgres"
  opt_twist_reporting_rds_pod_identity_associations = {
    ct-portal-data-etl = {
      namespace       = "ct-portal-data-etl",
      service_account = "ct-portal-data-etl-reporting-rds-access-sa"
    }
  }


  # Access to RDS:  "opt-ct/postgres"
  # Access to Cognito User Pool
  cognito_rds_pod_identity_associations = {
    ct-portal-backend-sa = {
      namespace       = "ct-portal-backend"
      service_account = "ct-portal-backend-sa"
    }
  }

}