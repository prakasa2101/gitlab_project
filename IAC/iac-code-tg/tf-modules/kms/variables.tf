variable "administrator_roles" {
  type = list(string)
}

variable "description" {
  type = string
}

variable "region" {
  type = string
}

variable "services" {
  type        = list(string)
  description = "list of services, like [s3.amazonaws.com]"
}

variable "condition" {
  type    = map(any)
  default = null
}

variable "additional_user_roles" {
  type    = list(string)
  default = null
}

variable "alias" {
  type = string
}
