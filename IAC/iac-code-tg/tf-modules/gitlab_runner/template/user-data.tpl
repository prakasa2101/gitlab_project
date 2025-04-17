#!/bin/bash

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install docker.io jq unzip mc 

# install aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# gitlab runner repository config
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash

# gitlab runner installation
sudo apt-get -y install gitlab-runner amazon-ecr-credential-helper 

mkdir -p /etc/gitlab-runner
cat > /etc/gitlab-runner/config.toml <<- EOF

concurrent = ${common["0"]["concurrent"]}
check_interval = 0

[session_server]
  session_timeout = 1800

EOF

%{ for item in config ~}
  aws_region=`curl http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}'`
  ssm_token=$(aws ssm get-parameters --names "${item["name"]}" --with-decryption --region $aws_region | jq -r ".Parameters | .[0] | .Value")

  if [[ `echo $ssm_token` == "null" ]]
    then
    token=$(curl --request POST --url "${common["0"]["url"]}/api/v4/user/runners" \
    --data "description=${item["name"]}" \
    --data "executor=${common["0"]["executor"]}" \
    --data "docker-image=${common["0"]["image"]}" \
    --data "tag_list=${item["tag_list"]}" \
    --data "run_untagged=${item["run_untagged"]}" \
    --data "maximum_timeout=${item["maximum_timeout"]}" \
    --data "locked=${item["locked_to_project"]}" \
    --data "project_id=${item["project_id"]}" \
    --data "runner_type=${item["runner_type"]}" \
    --header "PRIVATE-TOKEN: ${item["token"]}" \
    | jq -r .token)
    aws ssm put-parameter --overwrite --type SecureString  --name "${item["name"]}" --value $token --region "$aws_region"
  fi

ssm_token=$(aws ssm get-parameters --names "${item["name"]}" --with-decryption --region $aws_region | jq -r ".Parameters | .[0] | .Value")
cat >> /etc/gitlab-runner/config.toml <<- EOF

[[runners]]
  name = "${item["name"]}"
  url = "${common["0"]["url"]}"
  token = "$ssm_token"
  executor = "${common["0"]["executor"]}"
  [runners.custom_build_dir]
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]
    [runners.cache.azure]
  [runners.docker]
    tls_verify = false
    image = "${common["0"]["image"]}"
    privileged = false
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/cache"]
    shm_size = 0
    network_mtu = 0
    services_limit = -1
    environment = ["DOCKER_AUTH_CONFIG={ \"credsStore\": \"ecr-login\" }"]
  [runners.monitoring]

EOF

%{ endfor ~}


mkdir -p /root/.aws 
aws_account_id=$(aws sts get-caller-identity --query Account --output text)
aws_region=`curl http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}'`

cat >> /root/.aws/config <<- EOF
[default]
role_arn = arn:aws:iam::$aws_account_id:role/terraform-executor
credential_source = Ec2InstanceMetadata
region = $aws_region

EOF


mkdir -p /root/.docker
cat >> /root/.docker/config.json <<- EOF
{
 "credsStore": "ecr-login"
}

EOF



service gitlab-runner restart

#%{ for item in config ~}
#sudo /usr/bin/gitlab-runner register --non-interactive --name "${item["name"]}" --url "${common["0"]["url"]}" --registration-token "${item["token"]}" --executor "${common["0"]["executor"]}" --docker-image "${common["0"]["image"]}" --tag-list "${item["tag_list"]}" --run-untagged "${item["run_untagged"]}" --maximum-timeout "${item["maximum_timeout"]}" --locked "${item["locked_to_project"]}"  >> /var/log/runner_registration.log 2>&1
#%{ endfor ~}

