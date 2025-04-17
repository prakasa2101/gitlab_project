variable "region" {
  description = "Provide the region"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Provide the project"
  type        = string
  default     = "opt"
}

variable "app" {
  description = "Provide the project"
  type        = string
  default     = "ct"
}

variable "env" {
  description = "Provide the environment"
  type        = string
  default     = "dev"
}

variable "bucketname" {
  description = "Provide the terraform state bucket name"
  type        = string
  default     = "opt-ct-tf-state"
}

variable "ecstfpath" {
  description = "Provide the ct account backend terraform state path"
  type        = string
  default     = "account/environments/dev/ct-backend-terraform.tfstate"
}

variable "microservice1" {
  description = "Provide the ct account apis"
  type        = string
  default     = "login"
}

variable "microservice2" {
  description = "Provide the ct account apis"
  type        = string
  default     = "account"
}