#!/bin/bash -e

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