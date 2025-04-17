terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
backend "s3" {
  bucket         = "opt-ct-tf-state"
  key            = "account/environments/dev/eventbridge-terraform.tfstate"
  region         = "us-east-1"        
  encrypt        = true
  dynamodb_table = "opt-ct-tf-state-store"
  }
}

provider "aws" {
  region = var.region
}

resource "aws_cloudwatch_event_rule" "eb-rule" {
  name        = "${var.project}-${var.app}-${var.microservice}-${var.env}-eb"
  description = "Eventbridge"
  event_bus_name = "default"
  is_enabled = "true"
  event_pattern = jsonencode({
    source = [
      "Message received"
    ]
  })
  tags = {
    Application = var.app
    Environment = var.env
  }
}

resource "aws_cloudwatch_event_target" "cw" {
  target_id = "cw"
  rule      = aws_cloudwatch_event_rule.eb-rule.name
  arn       = aws_cloudwatch_log_group.cw-eb.arn
}

resource "aws_cloudwatch_log_group" "cw-eb" {
  name              = "/aws/events/${var.project}-${var.app}-${var.microservice}-${var.env}-eb"
  retention_in_days = 30
  tags = {
    Application = var.app
    Environment = var.env
  }
}

data "aws_iam_policy_document" "cw-eb-log-policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream"
    ]

    resources = [
      "${aws_cloudwatch_log_group.cw-eb.arn}:*"
    ]

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com",
        "delivery.logs.amazonaws.com"
      ]
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.cw-eb.arn}:*:*"
    ]

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com",
        "delivery.logs.amazonaws.com"
      ]
    }

    condition {
      test     = "ArnEquals"
      values   = [aws_cloudwatch_event_rule.eb-rule.arn]
      variable = "aws:SourceArn"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "cw-eb-policy" {
  policy_document = data.aws_iam_policy_document.cw-eb-log-policy.json
  policy_name     = "${var.project}-${var.app}-${var.microservice}-${var.env}-cw-eb-log-policy"
}

