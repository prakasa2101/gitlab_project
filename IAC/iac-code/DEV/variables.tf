### General variables
variable "aws_account" {
  description = "AWS account id"
  type        = string
}

variable "region" {
  description = "Provider S3 bucket name to store backend"
  type        = string
  default     = "us-east-1"
}

variable "administrator_roles" {
  description = "List of Account Administrators"
  type        = list(string)
}

variable "environment" {
  description = "Provider S3 bucket name to store backend"
  type        = string
}

variable "project_owner" {
  description = "Project owner"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "git_repo" {
  description = "Git repository"
  type        = string
}

variable "git_group" {
  description = "Project name"
  type        = string
  default     = "opt Med Tech"
}

variable "iac_mode" {
  description = "IAC mode"
  type        = string
  default     = "auto"
}

variable "iac_app" {
  description = "IAC application"
  type        = string
  default     = "terraform"
}

variable "dns_name" {
  description = "DNS Zone name"
  type        = string
}

### VPC specific variables
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

#variable "vpc_log_bucket_name" {
#  type        = string
#  description = "VPC flowlogs S3 bucket name"
#}

### EKS specific variables
variable "eks_version" {
  type        = string
  description = "EKS version"
}

variable "coredns_version" {
  type        = string
  description = "EKS addon version for coredns"
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

### Gitlab runner

### ----------------
### Aurora Postgresql Database
variable "aurora_engine" {
  type    = string
  default = null
}
variable "aurora_engine_version" {
  type    = string
  default = null
}
variable "aurora_engine_mode" {
  type    = string
  default = "provisioned"
}
variable "aurora_instance_class" {
  type = string
}

variable "aurora_is_serverless" {
  type    = bool
  default = null
}
variable "aurora_cluster_db_parameters" {
  type    = map(string)
  default = {}
}

variable "aurora_preferred_maintenance_window" {
  type        = string
  default     = "Mon:00:00-Mon:03:00"
  description = "Weekly time range during which system maintenance can occur, in (UTC)"
}

variable "aurora_preferred_backup_window" {
  type        = string
  default     = "04:00-06:00"
  description = "Daily time range during which automated backups. Time in UTC"
}
variable "aurora_backup_retention_period" {
  type        = string
  default     = "7"
  description = "Days to retain backups for"
}
variable "aurora_auto_minor_version_upgrade" {
  type        = bool
  default     = true
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
}

variable "aurora_allow_major_version_upgrade" {
  type        = bool
  default     = false
  description = "Enable to allow major engine version upgrades when changing engine versions. Defaults to false"
}
