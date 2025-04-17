# MAP of ECR objects 
variable "ecr_repositories" {
  type        = list(string)
  description = "Set of the repositories's names that should be created"
}
