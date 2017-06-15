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
* [Docker](https://docs.docker.com/engine/installation/linux/ubuntu/#install-using-the-repository)
* [AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/awscli-install-linux.html#awscli-install-linux-pip)
* [Jenkins](https://www.digitalocean.com/community/tutorials/how-to-install-jenkins-on-ubuntu-16-04) https://pkg.jenkins.io/debian-stable/
* [Terraform](https://www.terraform.io/intro/getting-started/install.html)
* [Terraform Docker Image Provider](https://github.com/zongoose/terraform-provider-docker-image)
* [Go](https://github.com/golang/go/wiki/Ubuntu)

### AWS ###
The infrastructure is deployed to an AWS cloud environment. It requires the following to be pre-configured:

* an S3 bucket for storing terraform state information, the region and bucket are configured in the init script
* an IAM user for CLI access, it should have read/write access to the S3 bucket

### Jenkins ###
The jenkins user must be added to the docker group to be able to build and deploy docker images.

`sudo usermod -aG docker jenkins`

Jenkins requires the following plugins to be installed:

* [Custom Tools Plugin}(https://wiki.jenkins-ci.org/display/JENKINS/Custom+Tools+Plugin)

## Installation Instructions ##
Once all pre-requisites have been installed run the 
The configuration for adding Terraform as a custom tool can be added by copying the jenkins/com.cloudbees.jenkins.plugins.customtools.CustomTool.xml file into the /var/lib/jenkins/ folder.

`cp -R ./jenkins/com.cloudbees.jenkins.plugins.customtools.CustomTool.xml /var/lib/jenkins/`

The Jenkins job can be installed by copying the jenkins/ha-wordpress folder into the /var/lib/jenkins/jobs/ folder.

`cp -R ./jenkins/ha-wordpress /var/lib/jenkins/jobs/`

The AWS CLI user access
* Configure ~./aws/credentials file for the Jenkins user
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
* Remove need for Jenkins to build docker images as by being a member of the docker group the jenkins user effectively has root user access