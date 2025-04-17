variable "environment" {
  description = "Provider S3 bucket name to store backend"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "region" {
  description = "Provider S3 bucket name to store backend"
  type        = string
  default     = "us-east-1"
}

variable "eks_version" {
  type        = string
  description = "EKS version"
}

variable "managed_node_group" {
  type = object({
    instance_types             = optional(list(string), ["m6in.large", "m6i.large", "m5n.large"])
    ami_id                     = optional(string, "")
    ami_type                   = optional(string, "BOTTLEROCKET_x86_64")
    platform                   = optional(string, "bottlerocket")
    cluster_ip_family          = optional(string, "ipv4")
    max_unavailable_percentage = optional(number, 50)
    disk_size                  = optional(number, 50)
    min_size                   = optional(number, 1)
    max_size                   = optional(number, 2)
    desired_size               = optional(number, 1)
    schedules                  = optional(map(any), {})
  })
  default = {}
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnets CIDR "
}

variable "cluster_endpoint" {
  type = string
}

variable "cluster_certificate_authority_data" {
  type = string
}

variable "cluster_service_cidr" {
  type = string
}

variable "node_security_group_id" {
  type = string
}
