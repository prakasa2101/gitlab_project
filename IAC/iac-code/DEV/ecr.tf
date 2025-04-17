# MAP of ECR objects 
variable "ecr_repositories" {
  type        = list(string)
  description = "Set of the repositories's names that should be created"
}

module "ecr_repositories" {
  # source = "git::https://gitlab.com/opt-med-tech/iac/tf-modules.git//ecr"
  source = "../tf-modules/ecr"


  for_each = toset(var.ecr_repositories)

  repository_name = each.key
  scan_on_push    = true # optional

}