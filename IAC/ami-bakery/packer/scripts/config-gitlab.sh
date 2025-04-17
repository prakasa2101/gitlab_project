# /bin/sh
sudo apt-get update
sudo apt-get -y upgrade
# Docker and dependencies
sudo apt-get -y install -y apt-transport-https ca-certificates curl software-properties-common docker.io jq unzip mc
sudo usermod -aG docker ${USER}

# Gitlab runner setup
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash

# gitlab runner installation
sudo apt-get -y install gitlab-runner amazon-ecr-credential-helper 

# Fleeting plugin for AWS instaces 
wget https://gitlab.com/gitlab-org/fleeting/plugins/aws/-/releases/v0.5.0/downloads/fleeting-plugin-aws-linux-amd64
sudo chmod +x fleeting-plugin-aws-linux-amd64  
sudo mv fleeting-plugin-aws-linux-amd64 /bin/fleeting-plugin-aws

# AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

# Pull gitlab-helper-image
sudo docker image pull registry.gitlab.com/gitlab-org/gitlab-runner/gitlab-runner-helper:x86_64-v17.1.0 
