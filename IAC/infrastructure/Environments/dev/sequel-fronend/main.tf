terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
backend "s3" {
  bucket         = "opt-ct-tf-state"
  key            = "account/environments/dev/account-frontend-terraform.tfstate"
  region         = "us-east-1"        
  encrypt        = true
  dynamodb_table = "opt-ct-tf-state-store"
  }
}

provider "aws" {
  region = var.region
}

data "terraform_remote_state" "previous_state" {
  backend = "s3"
  config = {
    bucket         = var.bucketname 
    key            = var.vpctfstatepath 
    region         = var.region 
  }
}

data "aws_caller_identity" "current" {}

locals {
  account-id = data.aws_caller_identity.current.account_id
}

#Create ecs cluster
resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.project}-${var.app}-${var.env}-${var.microservice}-ecs-cluster"
  tags = {
    Environment = var.env
    Application = var.app
  }
}

#Create ecs task definition
resource "aws_ecs_task_definition" "ecs-td" {
  family             = "${var.project}-${var.app}-${var.env}-${var.microservice}-td"
  requires_compatibilities = ["FARGATE"]
  network_mode       = "awsvpc"
  execution_role_arn = aws_iam_role.ecs-task-execution-role.arn
  cpu       = 1024
  memory    = 2048
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = jsonencode([
    {
      name      = "${var.project}-${var.app}-${var.env}-${var.microservice}"
      image     = "${local.account-id}.dkr.ecr.${var.region}.amazonaws.com/${var.project}-${var.app}-${var.env}-${var.microservice}:latest"
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = var.containerport
        } 
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = "${var.project}-${var.app}-${var.env}-${var.microservice}"
          awslogs-region = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
  tags = {
    Environment = var.env
    Application = var.app
  }
}


#Createb ecs service
resource "aws_ecs_service" "ecs-service" {
  name            = "${var.project}-${var.app}-${var.env}-${var.microservice}-ecs"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.ecs-td.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [data.terraform_remote_state.previous_state.outputs.private-subnet1-id, data.terraform_remote_state.previous_state.outputs.private-subnet2-id]
    security_groups = [aws_security_group.ecs-sg.id]
    assign_public_ip = "true"
  }

  force_new_deployment = true

  triggers = {
    redeployment = timestamp()
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "${var.project}-${var.app}-${var.env}-${var.microservice}"
    container_port   = var.containerport
  }
  tags = {
    Environment = var.env
    Application = var.app
  }
}

# ECS security group
resource "aws_security_group" "ecs-sg" {
  name        = "${var.project}-${var.app}-${var.env}-${var.microservice}-ecs-sg"
  description = "opt patient creation frontend security group"
  vpc_id      = data.terraform_remote_state.previous_state.outputs.vpc-id

  // Ingress rules (inbound rules)
  ingress {
    from_port   = 80  
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to the internet
  }

  ingress {
    from_port   = 443  
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to the internet
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to the internet
  }

  // Egress rules (outbound rules)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Environment = var.env
    Application = var.app
  }
}

#Create task execution role
resource "aws_iam_role" "ecs-task-execution-role" {
  name = "${var.project}-${var.app}-${var.env}-${var.microservice}-ecs-task-execution-role"
  assume_role_policy = jsonencode(
  {
    "Version": "2012-10-17",
    "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
  }
  )
  tags = {
    Environment = var.env
    Application = var.app
  }
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs-task-execution-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Create a Target Group
resource "aws_lb_target_group" "tg" {
  name        = "${var.project}-${var.app}-${var.env}-${var.ms}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.previous_state.outputs.vpc-id
  target_type = "ip"
  deregistration_delay = 30
  slow_start = 30
  health_check {
    path                = "/" # Customize as needed
    interval            = 40
    timeout             = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Environment = var.env
    Application = var.app
  }
}

# Create an Application Load Balancer
resource "aws_lb" "lb" {
  name               = "${var.project}-${var.app}-${var.env}-${var.ms}-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [data.terraform_remote_state.previous_state.outputs.public-subnet1-id, data.terraform_remote_state.previous_state.outputs.public-subnet2-id] 
  enable_deletion_protection = false
  enable_http2             = true
  idle_timeout            = 60
  security_groups          = [aws_security_group.lb-sg.id]
  tags = {
    Environment = var.env
    Application = var.app
  }
}

# Attach the Target Group to the Load Balancer
resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  # Attach the Target Group to the Listener
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
  tags = {
    Environment = var.env
    Application = var.app
  }
}

# ALB security group
resource "aws_security_group" "lb-sg" {
  name        = "${var.project}-${var.app}-${var.env}-${var.microservice}-lb-sg"
  description = "ct Account Frontend security group"
  vpc_id      = data.terraform_remote_state.previous_state.outputs.vpc-id

  // Ingress rules (inbound rules)
  ingress {
    from_port   = 80  
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to the internet
  }

  // Egress rules (outbound rules)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Environment = var.env
    Application = var.app
  }
}

