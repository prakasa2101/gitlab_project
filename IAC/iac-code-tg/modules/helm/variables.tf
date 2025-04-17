variable "environment" {
  description = "Provider S3 bucket name to store backend"
  type        = string
}

variable "eks_cluster_name" {
  type = string
}


variable "region" {
  description = "Provider S3 bucket name to store backend"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "aws_lb_controller_helm_version" {
  type        = string
  description = "Helm Chart version for aws-load-balancer-controller"
}

variable "aws_lb_controller_image_tag" {
  type        = string
  description = "Imgage tag version for aws-load-balancer-controller"
}

variable "external_dns_helm_version" {
  type        = string
  description = "Helm Chart version for external-dns"
}

variable "external_dns_image_tag" {
  type        = string
  description = "Imgage tag version for external-dns"
}

variable "external_dns_domains" {
  type        = list(string)
  description = "List of allowed domains for external-dns "
}

variable "secrets_store_csi_driver_helm_version" {
  type        = string
  description = "Helm Chart version for secrets_store_csi_driver"
}

variable "secrets_store_csi_driver_provider_aws_helm_version" {
  type        = string
  description = "Helm Chart version for secrets-store-csi-driver-provider-aws"
}

variable "vpc_id" {
  type = string
}

