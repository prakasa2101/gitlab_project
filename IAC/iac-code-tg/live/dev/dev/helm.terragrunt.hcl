# Include config from root terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

# Set module source
terraform {
  source = "../../../../modules/helm"
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
  eks_cluster_name                                   = local.common_tfvars.eks_cluster_name
  aws_account                                        = local.common_tfvars.aws_account
  aws_lb_controller_helm_version                     = local.common_tfvars.aws_lb_controller_helm_version
  project_name                                       = local.common_tfvars.project_name
  aws_lb_controller_helm_version                     = local.common_tfvars.aws_lb_controller_helm_version
  aws_lb_controller_image_tag                        = local.common_tfvars.aws_lb_controller_image_tag
  external_dns_helm_version                          = local.common_tfvars.external_dns_helm_version
  external_dns_image_tag                             = local.common_tfvars.external_dns_image_tag
  external_dns_domains                               = local.common_tfvars.external_dns_domains
  secrets_store_csi_driver_helm_version              = local.common_tfvars.secrets_store_csi_driver_helm_version
  secrets_store_csi_driver_provider_aws_helm_version = local.common_tfvars.secrets_store_csi_driver_provider_aws_helm_version
  environment                                        = local.common_tfvars.environment
  vpc_id                                             = dependency.vpc.outputs.vpc_id
}


# Teraform provider configuration - region where to deploy resources
generate "provider_kubernetes" {
  path      = "provider_kubernetes.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

data "aws_eks_cluster" "eks" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = var.eks_cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

EOF
}