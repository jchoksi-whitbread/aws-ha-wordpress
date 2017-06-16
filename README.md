# aws-ha-wordpress #
This repo contains the scripts and configuration required to deploy a scalable, high availability infrastructure on AWS for a Wordpress site. It is composed of the following AWS services:

* ECR docker container registry
* ECS docker container hosting
* ELB application load balancer
* Aurora database
* Autoscaling group to provision ECS cluster instances
* Cloudwatch alarms to trigger autoscaling in and out
* Route 53

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

* an S3 bucket for storing terraform state information, the region and bucket are configured in the init.sh script
* an IAM user for CLI access, it should have read/write access to the S3 bucket
* Route 53 DNS zone

### Jenkins ###
The jenkins user must be added to the docker group to be able to build and deploy docker images.

`sudo usermod -aG docker jenkins`

Jenkins requires the following plugins to be installed:

* [Custom Tools Plugin}(https://wiki.jenkins-ci.org/display/JENKINS/Custom+Tools+Plugin)

A Jenkins Secret credential must be configured for the RDS password in the terraform stack. It's credential ID should be "rdspassword".

## Installation Instructions ##
Once all pre-requisites have been installed checkout the repo and run the install script as root on the Jenkins server (to change permissions):

`git clone https://github.com/zongoose/aws-ha-wordpress.git`
`cd aws-ha-wordpress; sudo ./install.sh`

The AWS CLI user access key, secret key and region must be configured in ~./aws/credentials for the Jenkins user:

```
[default]
aws_access_key_id = <access_key>
aws_secret_access_key = <secret_key>
region = eu-west-1
```

Default variables can be overwritten in Jenkins using ENV variables within the Jenkins script.

## References ##
* [Terraform vs Ansible](https://blog.gruntwork.io/why-we-use-terraform-and-not-chef-puppet-ansible-saltstack-or-cloudformation-7989dad2865c)
* [Jenkins Terraform Automation](https://objectpartners.com/2016/06/01/automating-terraform-projects-with-jenkins/)

## Future Improvements ##
* Automatic creation of the S3 state bucket if it doesn't exist
* Remote Terraform state locking
* Use Terraform modules and organise terraform structure better
* Make region and bucket name elements configurable through Jenkins job
* Define AWS CLI credentials through Jenkins credentials
* Remove need for Jenkins to build docker images as by being a member of the docker group the jenkins user effectively has root user access
* Add CloudFront caching