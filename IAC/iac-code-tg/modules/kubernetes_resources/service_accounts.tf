## SA for AWS Load Ballancer Controller
resource "kubernetes_service_account" "service-account" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = var.lb_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

## SA for External DNS
resource "kubernetes_service_account" "external-dns" {
  metadata {
    name      = "external-dns"
    namespace = "external-dns"
    labels = {
      "app.kubernetes.io/name" = "external-dns"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = var.external_dns_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

## SA for POD Identity access for ct-portal-backend namespace
resource "kubernetes_service_account" "rds-access-ct-portal-backend" {
  metadata {
    name      = "rds-access-ct-portal-backend-sa"
    namespace = "ct-portal-backend"
  }
}

## SA for POD Identity access for ct-portal-backend namespace
resource "kubernetes_service_account" "rds-access-ct-portal-data-etl" {
  metadata {
    name      = "rds-access-ct-portal-data-etl-sa"
    namespace = "ct-portal-data-etl"
  }
}

## SA for POD Identity access example
resource "kubernetes_service_account" "rds-access-example" {
  metadata {
    name      = "rds-access-example"
    namespace = "opt-sandbox"
  }
}

## SA for ct portal data etl reporting rds access
resource "kubernetes_service_account" "ct-portal-data-etl-reporting-rds-access-sa" {
  metadata {
    name      = "ct-portal-data-etl-reporting-rds-access-sa"
    namespace = "ct-portal-data-etl"
  }
}

## SA for ct-portal-backend POD
# Access to RDS and Cognito
resource "kubernetes_service_account" "ct-portal-backend" {
  metadata {
    name      = "ct-portal-backend-sa"
    namespace = "ct-portal-backend"
  }
}