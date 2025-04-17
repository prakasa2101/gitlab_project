variable "region" {
  description = "Provide the region"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Provide the environment"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Provide the project"
  type        = string
  default     = "opt"
}

variable "app" {
  description = "Provide the application"
  type        = string
  default     = "ct"
}

variable "microservice" {
  description = "Provide the microservice name"
  type        = string
  default     = "account-frontend"
}

variable "ms" {
  description = "Provide the microservice name"
  type        = string
  default     = "account-fe"
}

variable "containerport" {
  description = "Port on which opt Patient Creation Frontend container is running"
  type        = number
  default     = "3000"
}

variable "hostport" {
  description = "Port on which opt Patient Creation Frontend container mapping to host"
  type        = number
  default     = "80"
}

variable "cwgroupname" {
  description = "opt Patient Creation Frontend Logs group"
  type        = string
  default     = "account-frontend"
}

variable "bucketname" {
  description = "S3 bucket name where terraform state files are stored"
  type        = string
  default     = "opt-ct-tf-state"
}

variable "vpctfstatepath" {
  description = "VPC terraform statefile path"
  type        = string
  default     = "account/environments/dev/vpc-terraform.tfstate"
}
