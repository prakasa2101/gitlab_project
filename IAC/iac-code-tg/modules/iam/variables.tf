variable "aws_account" {
  description = "AWS account id"
  type        = string
}

variable "aurora_cluster_resource_ids" {
  description = "Aurora clusters resourse ids MAP"
  type        = map(string)
}

variable "s3_state_bucket" {
  description = "S3 bucket name to store tf state"
  type        = string
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "eks_cluster_name" {
  type = string
}

variable "cluster_oidc_issuer_url" {
  type = string
}

variable "identity_providers" {
  type = list(string)
}

variable "opt_twist_rds_pod_identity_associations" {
  description = "Map of namespace and service accounts to create pod identity associations."
  type        = map(any)
}

variable "opt_twist_reporting_rds_pod_identity_associations" {
  description = "Map of namespace and service accounts to create pod identity associations."
  type        = map(any)
}

variable "cognito_rds_pod_identity_associations" {
  description = "Map of namespace and service accounts to create pod identity associations."
  type        = map(any)
}


variable "cognito_user_pool_id" {
  type = string
}