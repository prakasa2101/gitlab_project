variable "region" {
  description = "Provide the region"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Provide the region"
  type        = string
  default     = "opt"
}

variable "app" {
  description = "Provide the region"
  type        = string
  default     = "ct"
}

variable "microservice" {
  description = "Provide the region"
  type        = string
  default     = "account"
}

variable "vpc-cidr" {
  description = "The IPv4 CIDR block for the VPC"
  type        = string
  default     = "172.20.0.0/16"
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "vpc"
}

variable "env" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "dev"
}

variable "subnet1-cidr" {
  description = "The IPv4 CIDR block for the subnet1"
  type        = string
  default     = "172.20.0.0/21"
}

variable "subnet2-cidr" {
  description = "The IPv4 CIDR block for the subnet2"
  type        = string
  default     = "172.20.8.0/21"
}

variable "subnet3-cidr" {
  description = "The IPv4 CIDR block for the subnet3"
  type        = string
  default     = "172.20.168.0/22"
}

variable "subnet4-cidr" {
  description = "The IPv4 CIDR block for the subnet4"
  type        = string
  default     = "172.20.172.0/22"
}

variable "az1" {
  description = "The Availability zone1"
  type        = string
  default     = "us-east-1a"
}

variable "az2" {
  description = "The Availability zone2"
  type        = string
  default     = "us-east-1b"
}

variable "tfstatebucketname" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "opt-tf-statefile"
}

variable "vpctfstatepath" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "environments/dev/vpc-terraform.tfstate"
}

variable "dynamodbname" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "opt-tf-state-store"
}


