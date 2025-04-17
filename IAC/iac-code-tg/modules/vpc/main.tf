### EIP for VPC NAT Gateway 
resource "aws_eip" "nat" {
  count  = 2
  domain = "vpc"
}

### VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "opt-ct-${var.environment}"
  cidr = var.vpc_cidr

  manage_default_security_group  = "true"
  default_security_group_egress  = []
  default_security_group_ingress = []

  azs              = ["${var.region}a", "${var.region}b"]
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.database_subnets

  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true

  reuse_nat_ips       = true
  external_nat_ip_ids = aws_eip.nat.*.id

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  }
}



