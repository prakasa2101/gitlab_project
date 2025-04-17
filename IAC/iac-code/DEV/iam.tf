### Policy for Developers access
resource "aws_iam_policy" "developer_access" {
  name        = "AWS-opt-Developer-Custom-Policy"
  description = "Developers access policy"

  policy = templatefile("iam_policies/developer_access.tpl", { aws_account = var.aws_account })
}

### Policy for DevOPS access
resource "aws_iam_policy" "devops_access" {
  name        = "AWS-DevOps-Engineer-Custom-Policy"
  description = "Developers access policy"

  policy = templatefile("iam_policies/devops_access.tpl", { aws_account = var.aws_account })

}

## Load Balancer Controler IAM Policy
resource "aws_iam_policy" "load_balancer_controller" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "AWS Load Balancer Controller IAM Policy"

  policy = file("iam_policies/lb_controller.json")
}

## IAM role for AWS Load Ballancer Controller
module "lb_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.17.1"
  create_role                   = true
  role_name_prefix              = "aws-lb-controller"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  number_of_role_policy_arns    = 1
  role_policy_arns              = [aws_iam_policy.load_balancer_controller.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
}


## External DNS IAM Policy
resource "aws_iam_policy" "external_dns" {
  name        = "AllowExternalDNSUpdates"
  description = "External DNS IAM Policy"

  policy = file("iam_policies/external_dns.json")
}

## IAM role for External DNS
module "external_dns_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.17.1"
  create_role                   = true
  role_name_prefix              = "external-dns"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  number_of_role_policy_arns    = 1
  role_policy_arns              = [aws_iam_policy.external_dns.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:external-dns:external-dns"]
}