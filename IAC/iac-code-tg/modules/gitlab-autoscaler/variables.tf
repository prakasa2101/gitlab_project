
####
# Common
####
variable "environment" {
  description = "Environment"
  type        = string
}
variable "region" {
  type    = string
  default = "us-east-1"
}


####
# Network
####
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}
variable "private_subnets" {
  description = "Subnet used for hosting the GitLab manager and runners."
  type        = list(string)
}
variable "private_subnets_cidr_blocks" {
  description = "Subnet CIDRs used for hosting the GitLab manager and runners."
  type        = list(string)
}


####
# GitLab Runner
#### 
variable "secure_parameter_store_runner_token_key" {
  description = "The key name used to store the Gitlab runner token in Secure Parameter Store"
  type        = string
  default     = "opt-ct-Runner-*"
}
variable "runner_instance_profile_name" {
  type        = string
  description = "IAM instance profile name"
}
variable "global_concurrent_jobs" {
  type    = number
  default = 50
}
variable "runner_instance_type" {
  type        = string
  description = "Runner Instance type"
  default     = "c6a.large"
}


### Gitlab Executor
variable "enable_terraform_executor_role" {
  description = "If set to True Terraform Executor and Gitlab Runner roles and policies will be created"
  type        = bool
  default     = false
}


####
# GitLab manager
#### 
variable "manager_instance_type" {
  type        = string
  description = "Runner Instance type"
  default     = "t3a.medium"
}
variable "manager_autoscaling_group" {
  type    = string
  default = "Gitlab-Manager-AutoScalingGroup"
}
variable "manager_ami_name_prefix" {
  description = "AMI filter for the Gitlab Manager AMI - from packer."
  type        = string
  default     = "gitlab-runner-ami"
}
variable "manager_ami_owner" {
  description = "The list of owners used to select the AMI of Gitlab runner instances."
  type        = list(string)
}

# scaling - by default 1 - to ensure one manager running all the time
variable "manager_min_size" {
  type    = number
  default = 1
}
variable "manager_max_size" {
  type    = number
  default = 1
}
variable "manager_desired_capacity" {
  type    = number
  default = 1
}
variable "gitlab_manager_name" {
  description = "Gitlab Manager instance name"
  type        = string
  default     = "Gitlab-AutoScaler-Manager"
}


#### Manager Registration Projects
variable "manager_projects" {
  type = map(object({
    project_name          = string
    project_id            = string
    token                 = optional(string, "")
    tags                  = string
    concurrent            = optional(number, 1)
    max_instances         = optional(number, 1)
    max_use_count         = optional(number, 1)
    idle_time             = optional(string, "10m0s")
    capacity_per_instance = optional(number, 1)
    instance_type         = optional(string, "")
  }))

}

