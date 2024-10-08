# Helm Chart
## Introduction
This repo contains following components.
- A java web application source code in folder **javaWebApp**.
- **Dockerfile** to build docker image of **javaWebApp**.
- Helm chart in folder **javaWebAppHelm** to run **javaWebApp** in K8S cluster.
- A bash script **run-helm.sh** which can spin up **javaWebApp** from helm chart available in this repo.
- GitHub Actions in **.github** folder. This folder contains it's own readme file. Please have a look [on it](https://github.com/iam-jawad/app-with-helm/blob/main/.github/github-actions.md) to properly setup github actions automation on this repo.

## Pre-Requisite
### If building docker image manually
If you are trying to build docker image so please make sure that you have docker installed and running properly in whatever 
environment you are trying to build docker image.\
For more information about building docker image please refer **Dockerfile Section** down below.

### If installing helm chart manually on K8S cluster
If you are trying to install helm chart manually in K8S cluster so please make sure following things.
1) Helm should be installed and properly working on environment.
2) Set values in **values.yaml**, default values will also work but dubble check those values according to your environment configurations. For more information about setting variables please refer **Helm Chart Section** down below.
3) You must have installed **Nginx ingress controller** on your K8S cluster. You can install it with following command. (This step is for deployment other than EKS only. For EKS, AWS LoadBalancer Controller will be deployed by Terraform. If you have used [this repo](https://github.com/iam-jawad/iac-with-terraform) to provisioning infrastructure on AWS)
```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
```
4) Make sure you have deployed metrics server and it is working properly on your cluster (This step is for local deployment only. For EKS it will be done by Terraform. If you have used [this repo](https://github.com/iam-jawad/iac-with-terraform) to provisioning infrastructure on AWS)

## Java Web App

The folder **javaWebApp** which is on root of this repo contains source code of a basic java web app which was created using [Spring Boot](start.spring.io).\
Following are the configurations of java app.
- Build automation tool **maven**
- Language **Java** Version **21**
- Spring boot version **3.3.2**
- Packaging type **jar**
- Project has only one dependency which is **Spring Web**

When you will run this application so it will show following text on root of domain.\
**Hi, This is Jawad's DevOps assessment.**\
If you see above message after deploying and hitting the app on root of domain, so that means application is working perfect.

## Dockerfile

To containerize the app a docker file is also given on root of this repo.\
This docker file is building image from jdk 21 official Java docker image and getting a pre build **.jar** from following path in repo.\
```javaWebApp/target/javaWebApp-0.0.1-SNAPSHOT.jar```
If you want to copy your own jar file in docker image, so pass jar file path as ```--build-arg JAR_PATH=<jar file path>``` to Dockerfile while running docker build command.

To build docker image you can run following command.
```sh
docker build . -t <docker-registry>:<tag>
```

A pre build image is also can be pulled from my public docker registry.
```sh
docker pull docker.io/jawad57903/demo-app:latest
```

## Helm Chart

The folder **javaWebApp-helm** contains all files related to helm chart by using which you can deploy this Java Web App on any K8S cluster.\
Just edit environment variables according to your requirements in ```javaWebApp-helm/values.yaml```\
Following are few variables which you must consider changing.
1) **clusterEnvironmentEks**, Set this variable to false if you are not deploying this hlem chart on EKS. By using this variable ingress resource decides whether to add annotations for AWS LoadBalancer Controller or Nginx Ingress controller.
2) **repository and tag**, Set these variables and make sure your cluster have access to specified repo so that pods can pull image. I have set default value to my public docker repo image. You can use it for deploying and testing this helm chart on any cluster as far as it will have conectivity to internet.
3) **host**, This variable sets the host name from which ingress resource will be accepting traffic. Default value is empty which acts as wildcard and user will be able to access app by directly hiting Cluster/LoadBlancer IP address. If you will set this variable, so please make sure to do DNS configurations for the host that you will specify so that it can resolve traffic to cluster.

After that either you can deploy it directly using helm command or by using **run-helm.sh** bash script available in this repo.\
The final deployment will consist of following objects.
- Namespace
- Deployment
- Service
- Ingress
- Horizontal Pod Autoscaler
- Pod Disruption Budget

## Bash Script to Run Helm Chart

This repo also contains a bash script **run-helm.sh** which can be used to install helm chart.\
Following is the usage guide.
```sh
To install or upgrade Helm chart run the following command:
./run-helm.sh -install -revisionName <name> -path <path-to-helm-chart>
To uninstall Helm chart run the following command:
./run-helm.sh -uninstall -revisionName <name>
```