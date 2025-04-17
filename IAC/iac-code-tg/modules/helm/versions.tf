terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.48"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.7"
    }
  }
  required_version = "~> 1.8.2"
}
