variable "terraform_executor_role_name" {
  description = "Terraform executor role name"
  type        = string
  default     = "terraform-executor"
}
variable "gitlab_runner_role_name" {
  description = "Gitlab runner role name"
  type        = string
  default     = "gitlab-runner"
}

variable "secure_parameter_store_runner_token_key" {
  description = "The key name used to store the Gitlab runner token in Secure Parameter Store"
  type        = string
  default     = "opt-ct-Runner-*"
}

