#!/bin/bash -e

# Copy the Custom Tool Plugin config with Terraform configured
if [ ! -e /var/lib/jenkins/com.cloudbees.jenkins.plugins.customtools.CustomTool.xml ]; then
  if [ -d /var/lib/jenkins ]; then
    cp ./jenkins/com.cloudbees.jenkins.plugins.customtools.CustomTool.xml /var/lib/jenkins/
    chown jenkins:jenkins /var/lib/jenkins/com.cloudbees.jenkins.plugins.customtools.CustomTool.xml
  else
    echo "Jenkins folder not found!"
  fi
else
   echo "Jenkins Custom Tool Plugin config already exists!"
fi

# Copy the ha-wordpress job folder into the jenkins job folder
if [ ! -d /var/lib/jenkins/jobs/ha-wordpress ]; then
  if [ -d /var/lib/jenkins ]; then
    cp -R ./jenkins/ha-wordpress /var/lib/jenkins/jobs/
    chown -R jenkins:jenkins /var/lib/jenkins/jobs/ha-wordpress
  else
    echo "Jenkins folder not found!"
  fi
else
   echo "Jenkins ha-wordpress job folder already exists!"
fi