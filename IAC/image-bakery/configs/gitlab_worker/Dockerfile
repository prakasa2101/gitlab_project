FROM ubuntu:22.04

LABEL maintainer="john Karendys <john.karendys@optctblox.com>"

#Setup
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Configuration
ENV PACKER_VERSION=1.10.3
ENV TERRAFORM_VERSION=1.8.3
ENV TERRAGRUNT_VERSION=v0.59.4
ENV TFSEC_VERSION=v1.28.6
ENV AWS_CLI_VERSION=2.15.46
ENV KUBECTL_VERSION=1.29.4
ENV CRANE_VERSION=0.19.1
ENV TF_DOCS_VERSION=v0.18.0

# Dependencies
RUN apt update && apt -y install git bash wget jq curl unzip python3-pip software-properties-common apt-transport-https ca-certificates gnupg &&\
    rm -rf /var/lib/apt/lists

# Packer installation
ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip ./
RUN echo "===> installing Packer..." &&\
    unzip -qo packer_${PACKER_VERSION}_linux_amd64.zip -d /bin &&\
    rm -f packer_${PACKER_VERSION}_linux_amd64.zip &&\
    packer --version

#Terraform installation
ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip ./
RUN echo "===> installing Terraform..." &&\
    unzip -qo terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin &&\
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip &&\
    terraform --version
    
# AWS-cli v2 installation
RUN echo "===> installing AWS-cli v2..." &&\
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -o "awscliv2.zip" &&\
    unzip awscliv2.zip &&\
    ./aws/install &&\
    aws --version &&\
    rm -rf awscliv2.zip\
    aws\
    /usr/local/aws-cli/v2/current/dist/aws_completer\
    /usr/local/aws-cli/v2/current/dist/awscli/data/ac.index\
    /usr/local/aws-cli/v2/current/dist/awscli/examples &&\
    find /usr/local/aws-cli/v2/current/dist/awscli/botocore/data -name examples-1.json -delete 

# install tfsec
ADD "https://github.com/aquasecurity/tfsec/releases/download/${TFSEC_VERSION}/tfsec-linux-amd64" ./
RUN echo "===> installing TfSec..." &&\
    mv tfsec-linux-amd64 /bin/tfsec &&\
    rm -f tfsec-linux-amd64 &&\
    chmod a+x /bin/tfsec &&\
    tfsec --version

# Install checkov scanner
RUN pip3 install checkov    

# # Kubectl install
RUN curl -LO "https://dl.k8s.io/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl" &&\
    mv kubectl /usr/local/bin &&\
    chmod a+x /usr/local/bin/kubectl &&\
    kubectl version --client 

# Crane install
RUN curl -sL "https://github.com/google/go-containerregistry/releases/download/v$CRANE_VERSION/go-containerregistry_Linux_x86_64.tar.gz" > go-containerregistry.tar.gz
RUN tar zxvf go-containerregistry.tar.gz &&\
  mv crane /usr/local/bin &&\
  mv gcrane /usr/local/bin &&\
  mv krane /usr/local/bin &&\
  rm go-containerregistry.tar.gz

# Install Terrform-docs
RUN curl -sSLo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/$TF_DOCS_VERSION/terraform-docs-$TF_DOCS_VERSION-linux-amd64.tar.gz
RUN tar -xzf terraform-docs.tar.gz &&\
    chmod +x terraform-docs &&\
    mv terraform-docs /usr/local/bin

# Install Terragrunt
RUN curl -sSLo ./terragrunt_linux_amd64  https://github.com/gruntwork-io/terragrunt/releases/download/$TERRAGRUNT_VERSION/terragrunt_linux_amd64
RUN mv terragrunt_linux_amd64 /usr/local/bin/terragrunt &&\
    chmod a+x /usr/local/bin/terragrunt &&\
    terragrunt --version

# Cleanup
RUN apt remove -y software-properties-common &&\
  apt clean &&\
  rm -rf /tmp/*

  # Hardening
RUN chmod u-s /usr/bin/chsh /usr/bin/su /usr/bin/passwd /usr/bin/mount /usr/bin/umount /usr/bin/gpasswd /usr/bin/newgrp /usr/bin/chfn
RUN chmod g-s /usr/bin/wall /usr/sbin/pam_extrausers_chkpwd /usr/bin/expiry
RUN chmod g-s  /usr/bin/chage /usr/sbin/unix_chkpwd