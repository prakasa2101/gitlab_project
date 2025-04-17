
variable "environment" {
  description = "Provider S3 bucket name to store backend"
  type        = string
}

variable "runner_instance_type" {
  description = "Gitlab runner instance type"
  type        = string
  default     = "m5.large"
}

variable "region" {
  type    = string
  default = "us-east-1"
}


variable "s3_state_bucket" {
  description = "S3 bucket name to store tf state"
  type        = string
}


variable "private_subnets" {
  type        = list(string)
  description = "List of private subnets CIDR "
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "init_token_bakery" {
  type    = string
  default = "put token here only for initial deployment"
}
variable "init_token_iac" {
  type    = string
  default = "put token here only for initial deployment"
}


variable "init_token_app" {
  type    = string
  default = "put token here only for initial deployment"
}

variable "iac_concurrent_jobs" {
  type    = number
  default = 4
}



variable "iac_runner_min_size" {
  type    = number
  default = 1
}

variable "iac_runner_max_size" {
  type    = number
  default = 1
}

variable "iac_runner_desired_capacity" {
  type    = number
  default = 1
}

variable "app_runner_min_size" {
  type    = number
  default = 1
}

variable "app_runner_max_size" {
  type    = number
  default = 1
}

variable "app_runner_desired_capacity" {
  type    = number
  default = 1
}