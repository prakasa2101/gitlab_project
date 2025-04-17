

### VPC Endpoints
### SG for all Endpoints
resource "aws_security_group" "endpoint_access" {
  name = "endpoint-access-https"

  description = "Access to local endpoint on port 443"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = toset([module.vpc.private_subnets_cidr_blocks])
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "TCP"
      cidr_blocks = ingress.key
      description = "Access to endpoint from private subnets"
    }
  }
}


### ECR Endpoint 
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  policy              = null
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.endpoint_access.id]
}
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  policy              = null
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.endpoint_access.id]
}


### S3 Gateway - type Gateway
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  policy            = null
  route_table_ids   = module.vpc.private_route_table_ids
  vpc_endpoint_type = "Gateway"
}


### CloudWatch
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.endpoint_access.id]
  policy              = null
  subnet_ids          = module.vpc.private_subnets
}
resource "aws_vpc_endpoint_policy" "logs" {
  vpc_endpoint_id = aws_vpc_endpoint.logs.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AccessFromThisAccount"
        Effect = "Allow",
        Principal = {
          "AWS" = "*"
        },
        Action   = "*",
        Resource = "*"
      }
    ]
  })
}


### SQS 
resource "aws_vpc_endpoint" "sqs" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.sqs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  policy              = null
  security_group_ids  = [aws_security_group.endpoint_access.id]
  subnet_ids          = module.vpc.private_subnets
}


### SNS
resource "aws_vpc_endpoint" "sns" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.sns"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  policy              = null
  security_group_ids  = [aws_security_group.endpoint_access.id]
  subnet_ids          = module.vpc.private_subnets
}


### KSM
resource "aws_vpc_endpoint" "kms" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.kms"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.endpoint_access.id]
  policy              = null
  subnet_ids          = module.vpc.private_subnets
}
resource "aws_vpc_endpoint_policy" "kms" {
  vpc_endpoint_id = aws_vpc_endpoint.kms.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AccessFromThisAccount"
        Effect = "Allow",
        Principal = {
          "AWS" = "*"
        },
        Action   = "kms:*",
        Resource = "*"
      }
    ]
  })
}


# ### EFS - not needed yet
# resource "aws_vpc_endpoint" "efs" {
#   vpc_id              = module.vpc.vpc_id
#   service_name        = "com.amazonaws.${var.region}.elasticfilesystem"
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true
#   security_group_ids  = [aws_security_group.endpoint_access.id]
#   policy              = null
#   subnet_ids          = module.vpc.private_subnets
# }
# resource "aws_vpc_endpoint_policy" "efs" {
#   vpc_endpoint_id = aws_vpc_endpoint.efs.id
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Sid    = "AccessFromThisAccount"
#         Effect = "Allow",
#         Principal = {
#           "AWS" = "*"
#         },
#         Action   = "*",
#         Resource = "*"
#       }
#     ]
#   })
# }


