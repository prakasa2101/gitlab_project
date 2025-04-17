terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
backend "s3" {
  bucket         = "opt-ct-tf-state"
  key            = "account/environments/dev/vpc-terraform.tfstate"
  region         = "us-east-1"        
  encrypt        = true
  dynamodb_table = "opt-ct-tf-state-store"
  }
}

provider "aws" {
  region = var.region
}

###Create VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr
  enable_dns_hostnames = true
  tags = {
    Environment = var.env
    Name = "${var.project}-${var.app}-${var.env}-${var.microservice}"
  }
}

###Create Internet Gateway and NAT Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Environment = var.env
    Name = "${var.project}-${var.app}-${var.env}-${var.microservice}"
  }
}

resource "aws_eip" "eip" {
  domain           = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.subnet1.id

  tags = {
    Environment = var.env
    Name = "${var.project}-${var.app}-${var.env}-${var.microservice}"
  }

  depends_on = [aws_internet_gateway.igw]
}

###Create Public subnets
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnet1-cidr
  availability_zone = var.az1
  enable_resource_name_dns_a_record_on_launch = "true"
  map_public_ip_on_launch = "true"
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Environment = var.env
    Name = "${var.project}-${var.app}-${var.env}-${var.microservice}-public-subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnet2-cidr
  availability_zone = var.az2
  enable_resource_name_dns_a_record_on_launch = "true"
  map_public_ip_on_launch = "true"
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Environment = var.env
    Name = "${var.project}-${var.app}-${var.env}-${var.microservice}-public-subnet2"
  }
}

###Create private subnets
resource "aws_subnet" "subnet3" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnet3-cidr
  availability_zone = var.az1
  enable_resource_name_dns_a_record_on_launch = "true"
  map_public_ip_on_launch = "false"
  tags = {
    Environment = var.env
    Name = "${var.project}-${var.app}-${var.env}-${var.microservice}-private-subnet1"
  }
}

resource "aws_subnet" "subnet4" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnet4-cidr
  availability_zone = var.az2
  enable_resource_name_dns_a_record_on_launch = "true"
  map_public_ip_on_launch = "false"
  tags = {
    Environment = var.env
    Name = "${var.project}-${var.app}-${var.env}-${var.microservice}-private-subnet2"
  }
}

###Create public route table
resource "aws_route_table" "public-rt-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block = var.vpc-cidr
    gateway_id = "local"
  }

  tags = {
    Environment = var.env
    Name = "${var.project}-${var.app}-${var.env}-${var.microservice}-public-rt-table"
  }
}

###Create private route table
resource "aws_route_table" "private-rt-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }

  route {
    cidr_block = var.vpc-cidr
    gateway_id = "local"
  }

  tags = {
    Environment = var.env
    Name = "${var.project}-${var.app}-${var.env}-${var.microservice}-private-rt-table"
  }
}
