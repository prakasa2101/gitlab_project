#!/bin/bash


mkdir -p /root/.aws 
aws_account_id=$(aws sts get-caller-identity --query Account --output text)
aws_region=`curl http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}'`

cat >> /root/.aws/config <<- EOF
[default]
role_arn = arn:aws:iam::$aws_account_id:role/terraform-executor
credential_source = Ec2InstanceMetadata
region = $aws_region

EOF


