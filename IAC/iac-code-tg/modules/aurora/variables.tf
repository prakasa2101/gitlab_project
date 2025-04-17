variable "aurora_clusters" {
  type = map(any)
}


variable "tags" {
  type = map(string)
  default = {
    "iac:mode" = "auto"
    "iac:app"  = "terraform"
  }
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "database_subnet_group_name" {
  type        = string
  description = "Name of database subnet group"
}

variable "private_subnets_cidr_blocks" {
  type        = list(string)
  description = "List of cidr_blocks of private subnets"
}

variable "database_subnets" {
  type        = list(string)
  description = "List of IDs of database subnets"
}

variable "kms_keys" {
  type = map(any)
}

variable "kms_path" {
  type = string
}

variable "s3_state_bucket" {
  description = "S3 bucket name to store tf state"
  type        = string
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  description = "Provider S3 bucket name to store backend"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

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

variable "iam_database_authentication_enabled" {
  type        = bool
  default     = false
  description = "Enable database iam authentication. Defaults to false"
}
  