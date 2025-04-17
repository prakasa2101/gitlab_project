{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Action": [
                "ec2:*",
                "ecs:*",
                "rds-db:connect",
                "support:*",
                "s3:*",
                "eks:*",
                "eks-auth:*",
                "backup:*",
                "cloudtrail:*",
                "logs:*",
                "cloudwatch:*",
                "iam:GenerateCredentialReport",
                "iam:GenerateServiceLastAccessedDetails",
                "iam:Get*",
                "iam:List*",
                "iam:SimulateCustomPolicy",
                "iam:SimulatePrincipalPolicy",
                "iam:EnableMFADevice",
                "iam:CreateVirtualMFADevice",
                "iam:ResyncMFADevice",
                "iam:CreatePolicy",
                "iam:AttachRolePolicy",
                "iam:CreateRole",
                "iam:CreatePolicyVersion",
                "ecr:*",
                "sqs:*",
                "sns:*",
                "ses:*",
                "codepipeline:*",
                "codedeploy:*",
                "codebuild:*",
                "wafv2:*",
                "autoscaling:*",
                "guardduty:*",
                "rds:*",
                "codestar-connections:*",
                "codestar:*",
                "iam:DeletePolicy",
                "iam:DeletePolicyVersion"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "Statement2",
            "Effect": "Allow",
            "Action": [
                "cognito-identity:*",
                "cognito-idp:*",
                "cognito-sync:*",
                "iam:ListRoles",
                "iam:ListOpenIdConnectProviders",
                "iam:GetRole",
                "iam:ListSAMLProviders",
                "iam:GetSAMLProvider",
                "kinesis:ListStreams",
                "lambda:GetPolicy",
                "lambda:ListFunctions",
                "sns:GetSMSSandboxAccountStatus",
                "sns:ListPlatformApplications",
                "ses:ListIdentities",
                "ses:GetIdentityVerificationAttributes",
                "mobiletargeting:GetApps",
                "acm:ListCertificates",
                "lambda:GetAccountSettings",
                "lambda:GetFunction",
                "lambda:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "cognito-idp.amazonaws.com",
                        "email.cognito-idp.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:DeleteServiceLinkedRole",
                "iam:GetServiceLinkedRoleDeletionStatus"
            ],
            "Resource": [
                "arn:aws:iam::*:role/aws-service-role/cognito-idp.amazonaws.com/AWSServiceRoleForAmazonCognitoIdp*",
                "arn:aws:iam::*:role/aws-service-role/email.cognito-idp.amazonaws.com/AWSServiceRoleForAmazonCognitoIdpEmail*"
            ]
        },
        {
            "Sid": "Statement3",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAddresses",
                "ec2:DescribeCarrierGateways",
                "ec2:DescribeClassicLinkInstances",
                "ec2:DescribeCustomerGateways",
                "ec2:DescribeDhcpOptions",
                "ec2:DescribeEgressOnlyInternetGateways",
                "ec2:DescribeFlowLogs",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeLocalGatewayRouteTables",
                "ec2:DescribeLocalGatewayRouteTableVpcAssociations",
                "ec2:DescribeMovingAddresses",
                "ec2:DescribeNatGateways",
                "ec2:DescribeNetworkAcls",
                "ec2:DescribeNetworkInterfaceAttribute",
                "ec2:DescribeNetworkInterfacePermissions",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribePrefixLists",
                "ec2:DescribeRouteTables",
                "ec2:DescribeSecurityGroupReferences",
                "ec2:DescribeSecurityGroupRules",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeStaleSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeTags",
                "ec2:DescribeVpcAttribute",
                "ec2:DescribeVpcClassicLink",
                "ec2:DescribeVpcClassicLinkDnsSupport",
                "ec2:DescribeVpcEndpoints",
                "ec2:DescribeVpcEndpointConnectionNotifications",
                "ec2:DescribeVpcEndpointConnections",
                "ec2:DescribeVpcEndpointServiceConfigurations",
                "ec2:DescribeVpcEndpointServicePermissions",
                "ec2:DescribeVpcEndpointServices",
                "ec2:DescribeVpcPeeringConnections",
                "ec2:DescribeVpcs",
                "ec2:DescribeVpnConnections",
                "ec2:DescribeVpnGateways",
                "ec2:GetSecurityGroupsForVpc"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Statement4",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Statement5",
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "arn:aws:iam::${aws_account}:role/*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": [
                        "codebuild.amazonaws.com",
                        "codepipeline.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Sid": "Statement6",
            "Effect": "Allow",
            "Action": [
                "iam:PassRole"
            ],
            "Resource": [
                "arn:aws:iam::${aws_account}:role/opt-ct-test-account-backend-ecs-task-role",
                "arn:aws:iam::${aws_account}:role/opt-ct-test-ecs-task-execution-role",
                "arn:aws:iam::${aws_account}:role/opt-ct-uat-ecs-task-execution-role",
                "arn:aws:iam::${aws_account}:role/opt-ct-uat-account-backend-ecs-task-role",
                "arn:aws:iam::${aws_account}:role/service-role/*"
            ]
        }
    ]
}