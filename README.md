# hello-world ci-cd

This repo contains a simple hello-world java application around which a ci-cd pipeline is created using **jenkins, maven, nexus and docker**.

## Setup

All the tools as well as the application is hosted on a GCP virtual machine, the steps to login to the vm have been shared over the mail.

There is a [tools.sh](https://github.com/abhinav9842/hello-cicd/blob/main/ci-cd-stack/tools.sh) script present inside the ci-cd stack directory which pretty much installs and configures all the tools necessary for the pipeline. This script can be used to configure tools on a fresh vm.

## Application
The application is a simple hello-world app which is written in java. This app is currently deployed on the VM and you can [click here](http://34.131.24.68/) to view the hosted app.

## Pipeline
I have used **jenkins** to create the ci-cd pipeline, the scripted code is present in [Jenkinsfile](https://github.com/abhinav9842/hello-cicd/blob/main/Jenkinsfile). The pipeline can be manually triggered as well as a webhook is also configured so whenever someone checks in the code the job runs automatically.

The pipeline mainly has 5 stages
- **Build** - In this stage I am cloning the repo and use mvn package goal to compile and package the jar
- **Unit testing** - By using mvn test goal I am testing the application. Test failing will result in a failed build. 
- **Docker Image** - In this step I am containerizing the java application. You can go through the [Dockerfile](https://github.com/abhinav9842/hello-cicd/blob/main/Dockerfile) to see the all instructions used to build the image.
- **Artifact upload** - It is very important to store the artifacts created in a seperate repo. In this stage I am uploading the Docker Image on to the private docker registry hosted on nexus. I am using build number to tag the images to make sure images are unique.
- **Deploy** - In this stage I am deploying the application as a docker container. The application is being pulled from the private docker repository hosted on nexus. The application is listening on port 80.

## Usage

You can access jenkins by [clicking here](http://34.131.24.68:8080/)

Nexus can be accessed from [here](http://34.131.24.68:8081/#browse/browse)

The credentials for both have been shared over the mail.
