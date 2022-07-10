#! /bin/bash

# Install Java
sudo yum install java-1.8.0-openjdk.x86_64 -y 

# download and install Jenkins
yum update -y 
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo 
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install jenkins -y

# start Jenkins
service start jenkins

chkconfig jenkins on 

# Install Git SCM
sudo yum install git -y 
