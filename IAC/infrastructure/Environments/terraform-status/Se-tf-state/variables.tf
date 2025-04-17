variable "region" {
  description = "Provider S3 bucket name to store backend"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Provider S3 bucket name to store backend"
  type        = string
  default     = "opt"
}

variable "app" {
  description = "Provider S3 bucket name to store backend"
  type        = string
  default     = "ct"
}

variable "bucketname" {
  description = "Provider S3 bucket name to store backend"
  type        = string
  default     = "tf-state"
}

variable "tablename" {
  description = "Provider S3 bucket name to store backend"
  type        = string
  default     = "tf-state-store"
}

variable "iampolicy" {
  description = "Provider S3 bucket name to store backend"
  type        = string
  default     = "tf-state-policy"
}

variable "iamrole" {
  description = "Provider S3 bucket name to store backend"
  type        = string
  default     = "tf-state-role"
}

variable "iampolicyattachment" {
  description = "Provider S3 bucket name to store backend"
  type        = string
  default     = "tf-state-policy-attachment"
}

variable "instanceprofilename" {
  description = "Provider S3 bucket name to store backend"
  type        = string
  default     = "tf-state-instance-profile"
}
