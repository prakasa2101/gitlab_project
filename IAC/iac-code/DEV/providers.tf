provider "aws" {
  region = var.region
  default_tags {
    tags = {
      "environment"   = var.environment
      "project:owner" = var.project_owner
      "project:name"  = var.project_name
      "git:repo"      = var.git_repo
      "git:group"     = var.git_group
      "iac:mode"      = var.iac_mode
      "iac:app"       = var.iac_app
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.eks_auth.token
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.eks_auth.token
}