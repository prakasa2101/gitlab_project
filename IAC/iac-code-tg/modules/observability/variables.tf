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

variable "eks_cluster_name" {
  type = string
}
variable "kms_key_id" {
  type = string
}

variable "environment" {
  description = "Provider S3 bucket name to store backend"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}
