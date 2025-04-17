# Include config from root terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

# Set module source
terraform {
  source = "../../../../modules/eks"
}

# Set module dependencies
dependency "vpc" {
  config_path = "../../common/vpc"
}

# Set local vars from tfvars file
locals {
  common_tfvars = jsondecode(read_tfvars_file("../../common.tfvars"))
}

# Input values to use for the variables of the module
inputs = {
  eks_version                                        = local.common_tfvars.eks_version
  coredns_version                                    = local.common_tfvars.coredns_version
  kube_proxy_version                                 = local.common_tfvars.kube_proxy_version
  eks_pod_identity_agent_version                     = local.common_tfvars.eks_pod_identity_agent_version
  vpc_cni_version                                    = local.common_tfvars.vpc_cni_version
  amazon_cloudwatch_observability_version            = local.common_tfvars.amazon_cloudwatch_observability_version
  aws_lb_controller_helm_version                     = local.common_tfvars.aws_lb_controller_helm_version
  aws_lb_controller_image_tag                        = local.common_tfvars.aws_lb_controller_image_tag
  external_dns_helm_version                          = local.common_tfvars.external_dns_helm_version
  external_dns_image_tag                             = local.common_tfvars.external_dns_image_tag
  external_dns_domains                               = local.common_tfvars.external_dns_domains
  secrets_store_csi_driver_helm_version              = local.common_tfvars.secrets_store_csi_driver_helm_version
  secrets_store_csi_driver_provider_aws_helm_version = local.common_tfvars.secrets_store_csi_driver_provider_aws_helm_version
  app_opt_sandbox_principal_arn                   = local.common_tfvars.app_opt_sandbox_principal_arn
  namespaces                                         = local.common_tfvars.namespaces
  environment                                        = local.common_tfvars.environment
  project_name                                       = local.common_tfvars.project_name
  vpc_id                                             = dependency.vpc.outputs.vpc_id
  public_subnets                                     = dependency.vpc.outputs.public_subnets
  private_subnets                                    = dependency.vpc.outputs.private_subnets
  database_subnets                                   = dependency.vpc.outputs.database_subnets
}