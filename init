#!/bin/bash -e

PROJECT="$(basename `pwd`)"
BUCKET="ha-wordpress-infrastructure-state"
REGION="eu-west-1"

# Obtain an ECR login from AWS and initialises Docker with it.
docker() {
  if [ -e ~/.aws/credentials ]; then
    aws ecr get-login | bash
  else
    echo "AWS credentials missing!"
    exit 1
  fi
}

# Install required terraform plugin for Docker
terraform_plugin() {
  if [ ! -e /usr/local/bin/terraform-provider-docker-image ]; then
    if [ ! -d ~/go ]; then
        echo "Creating Go working directory"
        mkdir ~/go
    fi
    echo "Getting github.com/zongoose/terraform-provider-docker-image"
    go get github.com/zongoose/terraform-provider-docker-image
    echo "Building github.com/zongoose/terraform-provider-docker-image"
    go build github.com/zongoose/terraform-provider-docker-image
    echo "Moving terraform-provider-docker-image binary file into /usr/local/bin"
    mv terraform-provider-docker-image /usr/local/bin/
  else
    echo "terraform-provider-docker-image plugin is already installed"
  fi

  if [ ! -e  ~/.terraformrc ]; then
    echo "Creating terraform plugins config"
    cat > ~/.terraformrc <<- EOM
    providers {
      dockerimage = "/usr/local/bin/terraform-provider-docker-image"
    }
EOM
  else
    echo "Terraform plugin config already exists"
  fi
}

# Run terraform init to configure backend
terraform_init() {
    cat > terraform.tf <<- EOM
    terraform {
      backend "s3" {
        bucket = "${BUCKET}"
        key    = "${PROJECT}/terraform.tfstate"
        region = "${REGION}"
      }
    }
EOM
  terraform init
}

docker

terraform_plugin

terraform_init