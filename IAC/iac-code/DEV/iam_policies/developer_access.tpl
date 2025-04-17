  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:BatchGetSecretValue",
                "secretsmanager:ListSecrets",
                "secretsmanager:GetSecretValue",
                "secretsmanager:CreateSecret",
                "secretsmanager:PutSecretValue",
                "secretsmanager:UpdateSecret",
                "secretsmanager:UpdateSecretVersionStage",
                "secretsmanager:TagResource",
                "secretsmanager:UntagResource",
                "secretsmanager:DescribeSecret"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "Statement2",
            "Effect": "Allow",
            "Action": [
                "cognito-identity:ListIdentities",
                "cognito-identity:ListIdentityPools",
                "cognito-identity:DescribeIdentity",
                "cognito-identity:DescribeIdentityPool",
                "cognito-identity:GetCredentialsForIdentity",
                "cognito-identity:GetIdentityPoolAnalytics",
                "cognito-identity:GetIdentityPoolDailyAnalytics",
                "cognito-identity:GetIdentityPoolRoles",
                "cognito-identity:GetIdentityProviderDailyAnalytics",
                "cognito-identity:GetOpenIdToken",
                "cognito-identity:GetOpenIdTokenForDeveloperIdentity",
                "cognito-identity:LookupDeveloperIdentity",
                "cognito-identity:GetPrincipalTagAttributeMap",
                "cognito-identity:ListTagsForResource",
                "cognito-identity:GetId",
                "cognito-identity:UnlinkDeveloperIdentity",
                "cognito-identity:SetIdentityPoolRoles",
                "cognito-identity:TagResource"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "Statement3",
            "Effect": "Allow",
            "Action": [
                "cognito-idp:ListDevices",
                "cognito-idp:ListGroups",
                "cognito-idp:ListIdentityProviders",
                "cognito-idp:ListResourceServers",
                "cognito-idp:ListResourcesForWebACL",
                "cognito-idp:ListTagsForResource",
                "cognito-idp:ListUserImportJobs",
                "cognito-idp:ListUserPoolClients",
                "cognito-idp:ListUserPools",
                "cognito-idp:ListUsers",
                "cognito-idp:ListUsersInGroup",
                "cognito-idp:AdminListUserAuthEvents",
                "cognito-idp:DescribeIdentityProvider",
                "cognito-idp:DescribeResourceServer",
                "cognito-idp:DescribeRiskConfiguration",
                "cognito-idp:DescribeUserImportJob",
                "cognito-idp:DescribeUserPool",
                "cognito-idp:DescribeUserPoolClient",
                "cognito-idp:DescribeUserPoolDomain",
                "cognito-idp:GetCSVHeader",
                "cognito-idp:GetDevice",
                "cognito-idp:GetGroup",
                "cognito-idp:GetIdentityProviderByIdentifier",
                "cognito-idp:GetLogDeliveryConfiguration",
                "cognito-idp:GetSigningCertificate",
                "cognito-idp:GetUICustomization",
                "cognito-idp:GetUser",
                "cognito-idp:GetUserAttributeVerificationCode",
                "cognito-idp:GetUserPoolMfaConfig",
                "cognito-idp:GetWebACLForResource",
                "cognito-idp:TagResource",
                "cognito-identity:TagResource",
                "cognito-idp:AdminListDevices",
                "cognito-idp:AdminListGroupsForUser",
                "cognito-idp:AdminGetDevice",
                "cognito-idp:AdminGetUser",
                "cognito-idp:AdminAddUserToGroup",
                "cognito-idp:AdminConfirmSignUp"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "Statement4",
            "Effect": "Allow",
            "Action": [
                "lambda:ListFunctions",
                "lambda:ListAliases",
                "lambda:ListCodeSigningConfigs",
                "lambda:ListEventSourceMappings",
                "lambda:ListFunctionEventInvokeConfigs",
                "lambda:ListFunctionsByCodeSigningConfig",
                "lambda:ListFunctionUrlConfigs",
                "lambda:ListLayers",
                "lambda:ListLayerVersions",
                "lambda:ListProvisionedConcurrencyConfigs",
                "lambda:ListVersionsByFunction",
                "lambda:GetAccountSettings",
                "lambda:GetAlias",
                "lambda:GetCodeSigningConfig",
                "lambda:GetEventSourceMapping",
                "lambda:GetFunction",
                "lambda:GetFunctionCodeSigningConfig",
                "lambda:GetFunctionConcurrency",
                "lambda:GetFunctionConfiguration",
                "lambda:GetFunctionEventInvokeConfig",
                "lambda:GetFunctionUrlConfig",
                "lambda:GetLayerVersion",
                "lambda:GetLayerVersionPolicy",
                "lambda:GetPolicy",
                "lambda:GetProvisionedConcurrencyConfig",
                "lambda:GetRuntimeManagementConfig",
                "lambda:ListTags",
                "lambda:CreateAlias",
                "lambda:CreateFunction",
                "lambda:InvokeFunction",
                "lambda:InvokeFunctionUrl",
                "lambda:TagResource",
                "lambda:UpdateFunctionCode"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Statement5",
            "Effect": "Allow",
            "Action": [
                "sqs:SendMessage"
            ],
            "Resource": [
                "arn:aws:sqs:us-east-1:${aws_account}:opt-ct-dev-deka-mimic"
            ]
        },
        {
            "Sid": "Statement6",
            "Effect": "Allow",
            "Action": [
                "events:PutEvents",
                "events:PutRule",
                "events:PutTargets",
                "events:PutPermission",
                "events:ListRules",
                "events:ListTargetsByRule",
                "events:DescribeRule",
                "events:TagResource"
            ],
            "Resource": "*"
        }
    ]
}