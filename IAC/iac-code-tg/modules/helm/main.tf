
locals {
  eks_cluster_name = "${var.project_name}-${var.environment}"
}

## Helm config for AWS Load Ballancer Controller
resource "helm_release" "lb_controller" {
  name       = "aws-load-balancer-controller"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = var.aws_lb_controller_helm_version
  namespace  = "kube-system"

  set {
    name  = "image.tag"
    value = var.aws_lb_controller_image_tag
  }

  set {
    name  = "clusterName"
    value = local.eks_cluster_name
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  set {
    name  = "awsRegion"
    value = var.region
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
}


## Helm config for External DNS
resource "helm_release" "external-dns" {
  name             = "external-dns"
  chart            = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns"
  version          = var.external_dns_helm_version
  namespace        = "external-dns"
  create_namespace = true

  set {
    name  = "image.tag"
    value = var.external_dns_image_tag
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "external-dns"
  }

  set {
    name  = "policy"
    value = "sync"
  }

  set_list {
    name  = "domainFilters"
    value = var.external_dns_domains
  }

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name  = "txtOwnerId"
    value = "${var.project_name}-${var.environment}"
  }
}

## Helm config for Secrets Store CSI Driver
resource "helm_release" "secrets-store-csi-driver" {
  name       = "secrets-store-csi-driver"
  chart      = "secrets-store-csi-driver"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  version    = var.secrets_store_csi_driver_helm_version
  namespace  = "kube-system"

  set {
    name  = "enableSecretRotation"
    value = "true"
  }
}

## Helm config for Secrets Store CSI Driver Provider AWS
resource "helm_release" "secrets-store-csi-driver-provider-aws" {
  name       = "secrets-store-csi-driver-provider-aws"
  chart      = "secrets-store-csi-driver-provider-aws"
  repository = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  version    = var.secrets_store_csi_driver_provider_aws_helm_version
  namespace  = "kube-system"
}
