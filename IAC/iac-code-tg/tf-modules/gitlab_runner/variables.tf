variable "subnet_ids_gitlab_runner" {
  description = "Subnet used for hosting the GitLab runner."
  type        = list(string)
}

variable "runner_ami_filter" {
  description = "AMI filter for the Gitlab runner AMI."
  type        = list(string)
}

variable "runner_ami_owner" {
  description = "The list of owners used to select the AMI of Gitlab runner instances."
  type        = list(string)
}

variable "runner_name" {
  description = "Runner instance name"
  type        = string
}

variable "runner_instance_profile_name" {
  type        = string
  description = "IAM instance profile name"
}

variable "runner_instance_type" {
  type        = string
  description = "Runner Instance type"
}

variable "secure_parameter_store_runner_token_key" {
  description = "The key name used to store the Gitlab runner token in Secure Parameter Store"
  type        = string
  default     = "opt-ct-Runner-*"
}


variable "runner_min_size" {
  type    = number
  default = 1
}

variable "runner_max_size" {
  type    = number
  default = 1
}

variable "runner_desired_capacity" {
  type    = number
  default = 1
}

variable "gitlab_runner_registration_config" {
  description = "Configuration used to register the runner"
  type        = map(list(map(string)))
}

variable "aws_region" {
  description = "AWS region."
  type        = string

}

variable "vpc_id" {
  description = "Runner VPC Id"
  type        = string
}

variable "enable_terraform_executor_role" {
  description = "If set to True Terraform Executor and Gitlab Runner roles and policies will be created"
  type        = bool
  default     = false
}

variable "runner_root_volume_size" {
  description = "Root volume size for runner EC2 instance"
  type        = string
  default     = "40"
}

