variable "kms_keys" {
  type        = map(any)
  description = "Map of KMS keys"
}

variable "administrator_roles" {
  type = list(string)
}

variable "region" {
  type = string
}

variable "condition" {
  type    = map(any)
  default = null
}

variable "additional_user_roles" {
  type    = list(string)
  default = null
}
