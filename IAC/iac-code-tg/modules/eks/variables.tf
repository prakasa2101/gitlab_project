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

### EKS specific variables
variable "eks_version" {
  type        = string
  description = "EKS version"
}

variable "coredns_version" {
  type        = string
  description = "EKS addon version for coredns"
}

variable "eks_pod_identity_agent_version" {
  type        = string
  description = "EKS addon version for Eks Pod Identity Agent"
}

variable "kube_proxy_version" {
  type        = string
  description = "EKS addon version for kube-proxy"
}

variable "vpc_cni_version" {
  type        = string
  description = "EKS addon version for vpc-cni"
}

variable "amazon_cloudwatch_observability_version" {
  type        = string
  description = "EKS addon version for amazon-cloudwatch-observability"
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

### EKS Observability 
variable "metrics_scrape_interval" {
  type        = number
  default     = 60
  description = "Metrics scrape interval via Cloudwatch"
}
variable "force_flush_interval" {
  type        = number
  default     = 60
  description = "Logs flush interval"
}

variable "metrics_logs_retention_in_days" {
  type        = number
  default     = 30
  description = "Number of days to keep metrics logs data"

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

### Kubernetes namespace 
variable "namespaces" {
  type        = list(string)
  description = "List of namespaces"
}

variable "app_opt_sandbox_principal_arn" {
  type        = string
  description = "app-opt-sandbox user group role arn"
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "database_subnets" {
  type = list(string)
}

