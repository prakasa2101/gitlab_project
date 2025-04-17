
### Namespaces
variable "namespaces" {
  type        = list(string)
  description = "List of namespaces"
}


### Service Accounts
variable "external_dns_role_arn" {
  type = string
}

variable "lb_role_arn" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}