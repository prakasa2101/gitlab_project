
# APPlication Runners security group

resource "aws_security_group" "runner" {
  name   = "gitlab_${var.runner_name}_security_group"
  vpc_id = var.vpc_id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 8844
    to_port     = 8844
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Parameter value is managed by the user-data script of the gitlab runner instance

resource "aws_ssm_parameter" "runner_registration_token" {
  count = length(var.gitlab_runner_registration_config["config"])
  name  = var.gitlab_runner_registration_config["config"]["${count.index}"]["name"]
  type  = "SecureString"
  value = "null"

  lifecycle {
    ignore_changes = [
      value,
      insecure_value,
    ]
  }
}

#Autoscalling group for Gitlab runners.

resource "aws_autoscaling_group" "gitlab_runner_instance" {
  name                = "${var.runner_name}-autscalling-group"
  vpc_zone_identifier = var.subnet_ids_gitlab_runner

  min_size                  = var.runner_min_size
  max_size                  = var.runner_max_size
  desired_capacity          = var.runner_desired_capacity
  health_check_grace_period = 60
  launch_configuration      = aws_launch_configuration.gitlab_runner_instance.name

  tag {
    key                 = "Name"
    value               = var.runner_name
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
}

#Search for Runner AMI id

data "aws_ami" "runner" {
  most_recent = "true"

  filter {
    name   = "name"
    values = var.runner_ami_filter
  }

  owners = var.runner_ami_owner
}

#Runners launch template

resource "aws_launch_configuration" "gitlab_runner_instance" {
  security_groups             = [aws_security_group.runner.id]
  image_id                    = data.aws_ami.runner.id
  user_data                   = base64encode(templatefile("${path.module}/template/user-data.tpl", var.gitlab_runner_registration_config))
  iam_instance_profile        = var.runner_instance_profile_name
  associate_public_ip_address = false
  name_prefix                 = var.runner_name
  instance_type               = var.runner_instance_type

  root_block_device {
    volume_size = var.runner_root_volume_size
    volume_type = "standard"
  }

  lifecycle {
    create_before_destroy = true
  }
}

