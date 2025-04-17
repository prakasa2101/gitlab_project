# https://github.com/hashicorp/packer-plugin-amazon
packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

### Vars
variable "vpc_id" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "security_group_id" {
  type = string
}

## DATA
data "amazon-ami" "ubuntu" {
    region = "us-east-1"
    filters = {
        name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
        root-device-type = "ebs"
    }
    owners = ["099720109477"]
    most_recent = true
}


locals { 
  runner_ami_name = "gitlab-runner-ami-${formatdate("YYYY-MM-DD-hhmmss", timestamp())}"
}



source "amazon-ebs" "ubuntu" {
  ami_name                    = local.runner_ami_name
  instance_type               = "t3.medium"
  region                      = "us-east-1"
  source_ami                  = data.amazon-ami.ubuntu.id
  ssh_username                = "ubuntu"
  associate_public_ip_address = false
  communicator                = "ssh"
  # https://docs.aws.amazon.com/systems-manager/latest/userguide/install-plugin-debian-and-ubuntu.html
  ssh_interface               = "session_manager"
  iam_instance_profile        = "sequel-twiist-gitlab-runner"

  vpc_id                      = var.vpc_id
  subnet_id                   = var.subnet_id
  security_group_id           = var.security_group_id

  launch_block_device_mappings {
      device_name = "/dev/sda1"
      encrypted = true
      volume_type = "gp3"
      volume_size = 16
      delete_on_termination = true
  }
  
  tags = {
    "project:owner" = "sreinitz@sequelmedtech.com"
    "project:name"  = "sequel-twiist"
    "git:repo"      = "sequel-med-tech/iac/iac-code"
    "git:group"     = "Sequel Med Tech"
    "iac:mode"      = "auto"
    "iac:app"       = "terraform"
  }

}

build {
  sources = ["source.amazon-ebs.ubuntu"]
  provisioner "shell" {
    script = "./scripts/config-gitlab.sh"
  }
}
