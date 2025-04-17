variable "s3_state_bucket" {
  description = "Provider S3 bucket name to store backend"
  type        = string
}

variable "region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "The environment being used (dev, qa, stage, prod)"
  type        = string
}

variable "aws_ses_domain_identity_arn" {
  description = "The domain identity arn used for email configuration"
  type        = string
}

variable "aws_ses_domain" {
  description = "The domain identity name used for email configuration"
  type        = string
}