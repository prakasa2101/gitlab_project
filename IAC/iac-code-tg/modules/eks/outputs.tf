output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "node_security_group_id" {
  value = module.eks.node_security_group_id
}

output "cluster_service_cidr" {
  value = module.eks.cluster_service_cidr
}
