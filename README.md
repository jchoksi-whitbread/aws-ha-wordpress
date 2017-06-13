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
* [Terraform Docker Image Provider](https://github.com/diosmosis/terraform-provider-docker-image)
* [Go](https://github.com/golang/go/wiki/Ubuntu)

### AWS ###
The infrastructure is deployed to an AWS cloud environment. It requires an IAM user to be configured for CLI access with the following security groups:

* TBC

## Installation Instructions ##
* Ensure all pre-requirements are installed
* Copy the Jenkins job folder
* Configure the AWS region and IAM user access keys in the terraform.tfvars file

## Technology Choice References ##
* [Terraform vs Ansible](https://blog.gruntwork.io/why-we-use-terraform-and-not-chef-puppet-ansible-saltstack-or-cloudformation-7989dad2865c)

## Future Improvements ##
* Remote Terraform state file on S3 bucket
* Create install script for jenkins job
* Decide between pre-uploaded docker image deployment or upload at infrastructure creation deployment