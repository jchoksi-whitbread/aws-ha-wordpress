# aws-ha-wordpress #
This repo contains the scripts and configuration required to deploy a scalable, high availability infrastructure on AWS for a Wordpress site. It is composed of the following AWS services:

* ECR docker container registry
* ECS docker container hosting
* ELB application load balancer
* Aurora database

## Pre-Requirements ##

### Deployment Server ###
The infrastructure deployment server requires the following packages and tools to be installed:

Packages:
git
python
awscli

Tools:
* [Docker & Docker Compose](https://docs.docker.com/engine/installation/linux/ubuntu/#install-using-the-repository)
* [AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/awscli-install-linux.html#awscli-install-linux-pip)
* [Jenkins](https://www.digitalocean.com/community/tutorials/how-to-install-jenkins-on-ubuntu-16-04) https://pkg.jenkins.io/debian-stable/
* [Terraform](https://www.terraform.io/intro/getting-started/install.html)
* [Terraform Docker Image Provider](https://github.com/zongoose/terraform-provider-docker-image)
* [Go](https://github.com/golang/go/wiki/Ubuntu)

### AWS ###
The infrastructure is deployed to an AWS cloud environment. It requires the following to be pre-configured:

* an IAM user for CLI access
* an S3 bucket for storing terraform state information, the location and bucket name are configured within the terraform.tf file

## Installation Instructions ##
* Ensure all pre-requirements are installed
* Copy the Jenkins job folder
* Configure the AWS region in the terraform.tfvars file if required, it defaults to eu-west-1
* Configure IAM user access key, secret key and region in the ~/.aws/credentials file

## References ##
* [Terraform vs Ansible](https://blog.gruntwork.io/why-we-use-terraform-and-not-chef-puppet-ansible-saltstack-or-cloudformation-7989dad2865c)
* [Jenkins Terraform Automation](https://objectpartners.com/2016/06/01/automating-terraform-projects-with-jenkins/)

## Future Improvements ##
* Automatic creation of the S3 state bucket if it doesn't exist
* Remote Terraform state and locking on S3 bucket or Consul server
* Locking file on remote state bucket to prevent multiple deploys at once
* Create install script for jenkins job
* Decide between pre-uploaded docker image deployment or upload at infrastructure creation deployment