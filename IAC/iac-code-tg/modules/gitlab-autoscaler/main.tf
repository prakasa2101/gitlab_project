

### Gitlab Manager

## Manager registration data
locals {
  gitlab_manager_registration = {
    #### To get access to parameter store all runners names must follow convention opt-ct-Runner-<runner name>
    config = [
      for k, v in var.manager_projects :
      {
        "name"                  = "opt-ct-Runner-${upper(v.project_name)}-${upper(var.environment)}",
        "project_name"          = "${v.project_name}",
        "idle_time"             = "${v.idle_time}",
        "token"                 = "${v.token}",
        "tag_list"              = "${v.tags}",
        "project_id"            = "${v.project_id}"
        "capacity_per_instance" = "${v.capacity_per_instance}"
        "max_instances"         = "${v.max_instances}"
        "concurrent"            = "${v.concurrent}",
        "max_use_count"         = "${v.max_use_count}",
        "executor"              = "docker-autoscaler",
        "locked_to_project"     = "yes",
        "run_untagged"          = "no",
        "maximum_timeout"       = "3600",
        "runner_type"           = "project_type",
      }
    ],
    common = [
      { "url" = "https://gitlab.com", "concurrent" = "${var.global_concurrent_jobs}", "image" = "ubuntu:22.04", "executor" = "docker" }
    ]
  }


}



### SSM parameter
resource "aws_ssm_parameter" "gitlab_manager_registration_token" {
  for_each = var.manager_projects

  name  = "opt-ct-Runner-${upper(each.value.project_name)}-${upper(var.environment)}"
  type  = "SecureString"
  value = "null"

  lifecycle {
    ignore_changes = [
      value,
      insecure_value,
    ]
  }
}


# AGS for Gitlab Manager
resource "aws_autoscaling_group" "gitlab_manager_autoscaling_group" {
  name                = var.manager_autoscaling_group
  vpc_zone_identifier = var.private_subnets

  min_size                  = var.manager_min_size
  max_size                  = var.manager_max_size
  desired_capacity          = var.manager_desired_capacity
  health_check_grace_period = 60

  launch_template {
    id      = aws_launch_template.gitlab_manager.id
    version = aws_launch_template.gitlab_manager.latest_version
  }

  tag {
    key                 = "Name"
    value               = var.gitlab_manager_name
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 100
    }
  }
}
## Gitlab Manager Config
resource "aws_launch_template" "gitlab_manager" {

  name_prefix = "gitlab_manager"
  image_id    = data.aws_ami.gitlab.id


  iam_instance_profile {
    name = aws_iam_instance_profile.gitlab_manager_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.manager.id]
  }
  instance_type = var.manager_instance_type

  lifecycle {
    create_before_destroy = true
  }
  user_data = base64gzip(templatefile("${path.module}/template/manager-user-data.tpl", local.gitlab_manager_registration))
}



# AGS for Gitlab Runners
resource "aws_autoscaling_group" "gitlab_runner_autoscaling_group" {
  for_each = var.manager_projects

  name                = "opt-ct-Runner-ASG-${each.value.project_name}"
  desired_capacity    = 0
  min_size            = 0
  max_size            = each.value.max_instances
  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.gitlab_runner[each.key].id
    version = aws_launch_template.gitlab_runner[each.key].latest_version
  }

  tag {
    key                 = "Name"
    value               = "runner-autoscaler-${each.value.project_name}"
    propagate_at_launch = true
  }

  health_check_type = "EC2"

  lifecycle {
    ignore_changes = [
      desired_capacity
    ]
  }
  protect_from_scale_in = true
  suspended_processes   = ["AZRebalance"]


}

resource "aws_launch_template" "gitlab_runner" {
  for_each = var.manager_projects

  name_prefix = each.value.project_name
  image_id    = data.aws_ami.gitlab.id

  iam_instance_profile {
    name = var.runner_instance_profile_name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.gitlab_runner.id]
  }
  instance_type = each.value.instance_type != "" ? each.value.instance_type : var.runner_instance_type

  lifecycle {
    create_before_destroy = true
  }
  user_data = filebase64("${path.module}//template/runner-user-data.sh")
}






