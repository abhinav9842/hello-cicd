#!/usr/bin/bash

sudo yum install -y wget

#Installing Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum -y upgrade
sudo yum install -y jenkins java-11-openjdk-devel

#Start Jenkins
sudo systemctl daemon-reload && \
sudo systemctl enable --now jenkins

#install maven
sudo yum -y install maven

#Installing Docker
sudo yum update -y && \
sudo yum install -y yum-utils && \
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo && \
sudo yum  -y install docker-ce docker-ce-cli containerd.io && \
sudo systemctl enable --now docker && \
sudo systemctl enable --now containerd.service

sudo groupadd docker && \
sudo usermod -aG docker $USER && \
sudo usermod -aG docker jenkins && \
newgrp docker

#Intalling docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose && \
sudo chmod +x /usr/bin/docker-compose

#Starting nexus
docker-compose up -d
