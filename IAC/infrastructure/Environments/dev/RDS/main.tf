terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
backend "s3" {
  bucket         = "opt-ct-tf-state"
  key            = "account/environments/dev/rds-terraform.tfstate"
  region         = "us-east-1"        
  encrypt        = true
  dynamodb_table = "opt-ct-tf-state-store"
  }
}

provider "aws" {
  region = var.region
}

###VPC previous state
data "terraform_remote_state" "previous_state" {
  backend = "s3"
  config = {
    bucket         = var.bucketname
    key            = var.vpctfstatepath 
    region         = var.region 
  }
}

###Create RDS Username and Password with Security manager
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "secretmasterDB" {
  name = "${var.project}-${var.app}-${var.env}-${var.microservice}-rdssecretnew"
  tags = {
    Application = var.app
    Environment = var.env
  }
}

resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id = aws_secretsmanager_secret.secretmasterDB.id
  secret_string = <<EOF
   {
    "username": "administratoropt",
    "password": "${random_password.password.result}"
   }
EOF
}

locals {
  db_creds = jsondecode(aws_secretsmanager_secret_version.sversion.secret_string)
}

###Create RDS Security group
resource "aws_security_group" "rds-sg" {
  name        = "${var.project}-${var.app}-${var.env}-${var.microservice}-rds-sg"
  description = "rds security group"
  vpc_id      = data.terraform_remote_state.previous_state.outputs.vpc-id

  // Ingress rules (inbound rules)
  ingress {
    from_port   = 5432  
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc-cidr}"]  # Open to the internet
  }

  ingress {
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc-cidr}"]  # Open to the internet
  }

  // Egress rules (outbound rules)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Application = var.app
    Environment = var.env
  }

}

###Create RDS subnet group
resource "aws_db_subnet_group" "rds-subnet-group" {
  name       = "${var.project}-${var.app}-${var.env}-${var.microservice}-rds-subnet-group"
  subnet_ids = [data.terraform_remote_state.previous_state.outputs.private-subnet1-id, data.terraform_remote_state.previous_state.outputs.private-subnet2-id]

  tags = {
    Application = var.app
    Environment = var.env
  }
}

###Create RDS parameter group
resource "aws_db_parameter_group" "rds-parameter-group" {
  name   = "${var.project}-${var.app}-${var.env}-${var.microservice}-rds-parameter-group"
  family = "postgres15"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

###Create RDS
resource "aws_db_instance" "rds" {
  identifier             = "${var.project}-${var.app}-${var.env}-${var.microservice}-db"
  instance_class         = var.dbclass
  allocated_storage      = var.storage
  db_name                = var.dbname
  engine                 = "postgres"
  engine_version         = "15"
  username               = local.db_creds.username
  password               = local.db_creds.password
  db_subnet_group_name   = aws_db_subnet_group.rds-subnet-group.name
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  parameter_group_name   = aws_db_parameter_group.rds-parameter-group.name
  publicly_accessible    = false
  skip_final_snapshot    = true
  tags = {
    Application = var.app
    Environment = var.env
  }
}
