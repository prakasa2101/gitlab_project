variable "region" {
  description = "Provides the region"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Provides the project name"
  type        = string
  default     = "opt"
}

variable "app" {
  description = "Provides the application name"
  type        = string
  default     = "ct"
}

variable "microservice" {
  description = "Provide the microservice name"
  type        = string
  default     = "account"
}

variable "env" {
  description = "Provides the environment"
  type        = string
  default     = "dev"
}

variable "bucketname" {
  description = "Provider S3 bucket name to store backend"
  type        = string
  default     = "opt-ct-tf-state"
}

variable "vpctfstatepath" {
  description = "Provider VPC terraform state file"
  type        = string
  default     = "account/environments/dev/vpc-terraform.tfstate"
}

variable "vpc-cidr" {
  description = "Provider VPC CIDR"
  type        = string
  default     = "172.40.0.0/16"
}

variable "dbclass" {
  description = "Provides the RDS DB Class"
  type        = string
  default     = "db.m5.large"
}

variable "storage" {
  description = "Provides the RDS Storage"
  type        = string
  default     = "10"
}

variable "dbname" {
  description = "Provides the RDS DB Class"
  type        = string
  default     = "opt_dev"
}