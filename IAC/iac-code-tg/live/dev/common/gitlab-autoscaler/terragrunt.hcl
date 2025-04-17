# Include config from root terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

# Set module source
terraform {
  source = "../../../../modules/gitlab-autoscaler"
}

# Set module dependencies
dependency "vpc" {
  config_path = "../vpc"
}



# Set local vars from tfvars file
locals {
  common_tfvars = jsondecode(read_tfvars_file("../../common.tfvars"))
}

# Input values to use for the variables of the module
inputs = {
  environment                 = local.common_tfvars.environment
  private_subnets_cidr_blocks = local.common_tfvars.private_subnets
  // s3_state_bucket = local.common_tfvars.s3_state_bucket

  ## Network
  vpc_id          = dependency.vpc.outputs.vpc_id
  private_subnets = dependency.vpc.outputs.private_subnets
  ## Gitalb manager

  manager_ami_owner              = ["123456789012"]
  runner_instance_profile_name   = "opt-ct-gitlab-runner"
  enable_terraform_executor_role = true

  runner_name = "autoscaler-gitlab"

  manager_projects = {
    iac = {
      project_name          = "iac-code-tg"
      project_id            = "58961130"
      token                 = "glpat-aqed9zzjzymfUCi3dwa59999" # one-time token, valid only during initial registration 
      tags                  = "dev, opt_ct_iac_autoscaler"
      concurrent            = 20      # [optional] Max number of parallel job =  max_instances * capacity_per_instance
      max_use_count         = 4       # [optional] Max number of job, each runner can run, until machine is evicted 
      idle_time             = "10m0s" # [optional] Idle time, until machine is evicted
      capacity_per_instance = 2       # [optional] Number of parallel job per instance
      max_instances         = 10      # [optional] Max number of EC2 instances in ASG
    }

    bakery = {
      project_name          = "image-bakery"
      project_id            = "57593387"
      token                 = "glpat-s58tw-ZmUTBoqY4d-kXX999" # one-time token, valid only during initial registration  
      tags                  = "dev, opt_ct_bakery_autoscaler"
      concurrent            = 2 # [optional] Max number of parallel job =  max_instances * capacity_per_instance
      capacity_per_instance = 2 # [optional] Number of parallel job per instance
      max_instances         = 1 # [optional] Max number of EC2 instances in ASG
      max_use_count         = 5 # [optional] Max number of job, each runner can run, until machine is evicted                      
    }

    lambda = {
      project_name          = "iac-lambda"
      project_id            = "58961626"
      token                 = "glpat-DnzsTS2xGJskp5nqmxwuuuuu" # one-time token, valid only during initial registration 
      tags                  = "dev, opt_ct_lambda_autoscaler"
      concurrent            = 2       # [optional] Max number of parallel job =  max_instances * capacity_per_instance
      capacity_per_instance = 2       # [optional] Number of parallel job per instance
      max_instances         = 1       # [optional] Max number of EC2 instances in ASG
      idle_time             = "10m0s" # [optional] Idle time, until machine is evicted
      max_use_count         = 10      # [optional] Max number of job, each runner can run, until machine is evicted             

    }

    ami_bakery = {
      project_name          = "ami-bakery"
      project_id            = "57682146"
      token                 = "glpat-PLr3XkoVTdyAnYz1Hkf9999" # one-time token, valid only during initial registration 
      tags                  = "dev, opt_ct_ami_bakery_autoscaler"
      concurrent            = 2 # [optional] Max number of parallel job =  max_instances * capacity_per_instance
      capacity_per_instance = 2 # [optional] Number of parallel job per instance
      max_instances         = 1 # [optional] Max number of EC2 instances in ASG
      max_use_count         = 5 # [optional] Max number of job, each runner can run, until machine is evicted         
    }

    portal_integration_testing = {
      project_name          = "portal-integration-testing"
      project_id            = "58962017"
      token                 = "glpat-BnzszFK6uAW9CLSYM2Qo999" # one-time token, valid only during initial registration 
      tags                  = "dev, portal_integration_testing_autoscaler"
      concurrent            = 2             # [optional] Max number of parallel job =  max_instances * capacity_per_instance
      capacity_per_instance = 1             # [optional] Number of parallel job per instance
      max_instances         = 2             # [optional] Max number of EC2 instances in ASG
      max_use_count         = 5             # [optional] Max number of job, each runner can run, until machine is evicted 
      instance_type         = "c6a.2xlarge" # [optional] default c6a.large       
    }

    opt_ct_account_backend = {
      project_name          = "opt-ct-account-backend"
      project_id            = "58695282"
      token                 = "glpat-Pmc84jA-mwk8Fu_gZ-k9999" # one-time token, valid only during initial registration 
      tags                  = "dev, opt_ct_backend_runner"
      concurrent            = 2 # [optional] Max number of parallel job =  max_instances * capacity_per_instance
      capacity_per_instance = 1 # [optional] Number of parallel job per instance
      max_instances         = 2 # [optional] Max number of EC2 instances in ASG
      max_use_count         = 5 # [optional] Max number of job, each runner can run, until machine is evicted 
    }

    opt_ct_account_frontend = {
      project_name          = "opt-ct-account-frontend"
      project_id            = "58695425"
      token                 = "glpat-hF6xioxfDdaiJvUkZJ8Ssss" # one-time token, valid only during initial registration 
      tags                  = "dev, opt_ct_frontend_runner"
      concurrent            = 2 # [optional] Max number of parallel job =  max_instances * capacity_per_instance
      capacity_per_instance = 1 # [optional] Number of parallel job per instance
      max_instances         = 2 # [optional] Max number of EC2 instances in ASG
      max_use_count         = 5 # [optional] Max number of job, each runner can run, until machine is evicted 
    }

  }
}
