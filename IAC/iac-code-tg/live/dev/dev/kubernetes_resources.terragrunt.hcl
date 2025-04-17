# Include config from root terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

# Set module source
terraform {
  source = "../../../../modules/kubernetes_resources"
}

# Set module dependency with outputs
dependency "iam" {
  config_path = "../iam"
}

# Set module dependencies - for ordering only
dependencies {
  paths = ["../eks"]
}


# Set local vars from tfvars file
locals {
  common_tfvars = jsondecode(read_tfvars_file("../../common.tfvars"))
}

# Input values to use for the variables of the module
inputs = {
  eks_cluster_name = local.common_tfvars.eks_cluster_name

  # Namespaces data
  namespaces = local.common_tfvars.namespaces

  # Kubernetes Service Accounts for EKS components 
  external_dns_role_arn = dependency.iam.outputs.external_dns_role_arn
  lb_role_arn           = dependency.iam.outputs.lb_role_arn


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

EOF
}