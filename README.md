# aws-ha-wordpress #
This repo contains the scripts and configuration required to deploy a scalable, high availability infrastructure on AWS for a Wordpress site. It is composed of the following AWS services:

* ECR docker container registry
* ECS docker container hosting
* ELB application load balancer
* Aurora database
* Autoscaling group to provision ECS cluster instances
* Cloudwatch alarms to trigger autoscaling in and out
* Route 53

These are deployed through Terraform run by a Jenkins job. The Jenkins job takes advantage of Docker, AWS CLI, Terraform and a forked and modified Terraform Docker Image Provider plugin from https://github.com/diosmosis/terraform-provider-docker-image.

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
* Route 53 DNS zone (to be included as the dnsname variable below)

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

Default variables can be overwritten in Jenkins using ENV variables within the Jenkins script. You will need to do this for the default dnsname variable. This can be edited in the Jenkins job configuration script window  by editing the following line:

`withEnv(["TF_VAR_rdspassword=${RDSPW}"]) {`

to something like this:

`withEnv(["TF_VAR_rdspassword=${RDSPW}", "TF_VAR_dnsname=zongoose.uk."]) {`

## Running the job ##
When running the job in jenkins it will ask you in the console output or the job summary page to approve or deny the output plan by terraform before applying it.

Once delpoyed for the first time the app will be available on the dnsname you defined on a hawordpress sub domain.

`http://hawordpress.zongoose.uk`

## References ##
* [Terraform vs Ansible](https://blog.gruntwork.io/why-we-use-terraform-and-not-chef-puppet-ansible-saltstack-or-cloudformation-7989dad2865c)
* [Jenkins Terraform Automation](https://objectpartners.com/2016/06/01/automating-terraform-projects-with-jenkins/)

## Technology Choices ##
The basis of this project is Terraform which is a defined provisioning tool. This was chosen over something such as Chef or Ansible as it prevents configuration drift, is standalone (no client requirements) and allows changes or removal of the configured infrastructure once the initial deployment has taken place.

The wordpress app was created as a docker container to allow it to be easily deployed and managed without an additional configuration management tool above Terraform. This project includes docker build and upload steps but these could be split into a separate job or the deployment of docker images could be handled by a different method. This would be something worth consideration as it remove the need for the Jenkins server to be a member of the docker group, increasing security.

The AWS platform was chosen as it is the one with which I have most experience. It also integrates very well with Terraform and has a mature CLI interface. Documentation and support is plentiful for both AWS and infrastructure provisioning within it using Terraform.

The AWS platform also provides services which handle much of the scalability and high availability demands of the project. By employing a load balancer in front of the ECS container hosts the loss or failure of individual app servers is mitigated. The container service itself will attempt to relaunch any failed app's. The Aurora RDS backend transparently handles fail over and replication of the database and provides a cluster endpoint which can be used by the application which abstracts away the current master server.

Through the use of Cloudwatch alarms and autoscaling groups the number of ECS cluster instances and application resources (application docker instances) running can be scaled up and down based on CPU load. Currently it is configured for between 2 and 5 instances.

## Future Improvements ##
* Automatic creation of the S3 state bucket if it doesn't exist
* Remote Terraform state locking
* Use Terraform modules and organise terraform structure better
* Make region and bucket name elements configurable through Jenkins job
* Define AWS CLI credentials through Jenkins credentials
* Remove need for Jenkins to build docker images as by being a member of the docker group the jenkins user effectively has root user access
* Add CloudFront caching
* Add SSL support