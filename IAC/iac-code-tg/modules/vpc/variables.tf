variable "vpc_cidr" {
  type        = string
  description = "Cluster VPC primary CIDR block"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnets CIDR "
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnets CIDR "
}

variable "database_subnets" {
  type        = list(string)
  description = "List of database subnets CIDR "
}

variable "region" {
  description = "Provider S3 bucket name to store backend"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Provider S3 bucket name to store backend"
  type        = string
}

variable "eks_cluster_name" {
  type        = string
  description = "EKS cluster name"
}
