#!/bin/bash

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
  executor = "${item["executor"]}"
  limit = ${item["concurrent"]}

  # Docker Executor config
  [runners.docker]
    tls_verify = false
    image = "${common["0"]["image"]}"
    privileged = false
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/cache"]
    pull_policy = ["if-not-present"]
    shm_size = 0
    network_mtu = 0
    services_limit = -1
    environment = ["DOCKER_AUTH_CONFIG={ \"credsStore\": \"ecr-login\" }"]
    helper_image = "registry.gitlab.com/gitlab-org/gitlab-runner/gitlab-runner-helper:x86_64-v17.1.0"

  # Autoscaler config
  [runners.autoscaler]
    plugin = "fleeting-plugin-aws"
    capacity_per_instance = ${item["capacity_per_instance"]}
    max_use_count = ${item["max_use_count"]}
    max_instances = ${item["max_instances"]}

  # https://docs.gitlab.com/runner/configuration/advanced-configuration.html

    [runners.autoscaler.plugin_config] # plugin specific configuration (see plugin documentation)
      name              = "opt-ct-Runner-ASG-${item["project_name"]}"
      region            = "$aws_region"

    [runners.autoscaler.connector_config]
      username          = "ubuntu"
      protocol          = "ssh"
      use_external_addr = false

    [[runners.autoscaler.policy]]
      idle_count = 0
      idle_time = "${item["idle_time"]}"


  [runners.custom_build_dir]
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]
    [runners.cache.azure]
  [runners.monitoring]

EOF

%{ endfor ~}


mkdir -p /root/.aws 
aws_account_id=$(aws sts get-caller-identity --query Account --output text)
aws_region=`curl http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}'`

cat >> /root/.aws/config <<- EOF
[default]
region = $aws_region

EOF


mkdir -p /root/.docker
cat >> /root/.docker/config.json <<- EOF
{
 "credsStore": "ecr-login"
}

EOF

service gitlab-runner restart

