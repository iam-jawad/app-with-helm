# DevOpsAssessment
## Intrduction
This repo contains following components.
- A java web application source code in folder **javaWebApp**.
- **Dockerfile** to build docker image of **javaWebApp**.
- Helm chart in folder **javaWebAppHelm** to run **javaWebApp** in K8S cluster.
- A bash script **run-helm.sh** which can spin up **javaWebApp** from helm chat available in this repo.
- Terraform code in folder **terraform-code** for more details about it please have a look on Terraform Code section down below.

## Pre-Requisite
### If building docker image
If you are trying to build docker image so please make sure that you have docker installed and running properly in whatever 
environment you are trying to build docker image.

### If installing helm chart on K8S cluster
If you are trying to install helm chart in K8S cluster so please make sure following three things.
1) Set values in **values.yaml** default values will also work but dubble check those values according to your environment configurations.
2) Check if helm is installed on environemnt otherwise **run-helm.sh** will through an error that "Helm is not installed." and exit.
3) You must have installed **Nginx ingress controller** on your K8S cluster. You can install it with following command.\
```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
```
4) Whatever host name you will set in **values.yaml**, please make sure to do necessary DNS configuration for resolving host name to Cluster/LoadBalancer IP address. Default value for host is empty which acts as wildcard and user will be able to access app by directly hiting Cluster/LoadBlancer IP address.
5) Make sure you have deployed metrics server and it is working properly on your cluster (This step is for local deployment only. For EKS it will be done by Terraform)

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
If you see above message after deploying and hitting the app on root of domain so that means application is working perfect.

## Dockerfile

To containerize the app a docker file is also given on root of this repo.\
This docker file is building image from jdk 21 official Java docker image and getting a pre build **.jar** from following path in repo.\
```javaWebApp/target/javaWebApp-0.0.1-SNAPSHOT.jar```

To build docker image you can run following command.\
```sh
docker build . -t <docker-registry>:<tag>
```

A pre build image is also can be pulled from my public docker registry.\
```sh
docker pull docker.io/jawad57903/demo-app:latest
```

## Helm Chart

The folder **javaWebApp-helm** contains all files related to helm chart by using which you can deploy this Java Web App on any K8S cluster.\
Just edit environment variables according to your needs in ```javaWebApp-helm/values.yaml```\
After that either you can deploy it directly using helm command or by using **run-helm.sh** bash script available in this repo.\
The final K8S deployment will consist of following objects.
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
To install Helm chart run the following command:
./run-helm.sh -install -revisionName <name> -path <path-to-helm-chart>
To uninstall Helm chart run the following command:
./run-helm.sh -uninstall -revisionName <name>
```

## Terraform Code
Terraform code for provisioning infrastructure on AWS could be found in folder **terraform-code** on root of this repo.\
To run this code you must have AWS CLI installed and configured along with terraform on environment from where you will be executing this code.\
This code will provision following resources in your AWS account.
1) VPC
2) Four Subnets (two public and two private).
3) A Nat Gateway (this will be attached in one of the public subnets to provide secure internet conectivity to pods deployed in private subnets).
4) A Internet Gateway.
5) Two Route Tables (one with rule to route traffic from private subnets to nat gateway and other with rule to route traffic between public subnets and internet gateway).
6) EKS Cluster using Fargate (all required IAM policies and roles also will be created).
7) A OIDC Provider for EKS cluster conectivity with other AWS resources.
8) Two Fargate Profiles (one for kube-system namespace and other for custom namespace in which you can deploy application using helm code available in this repo. To improve security both profiles will be attached with private subnets so that pods can be deployed only in private subnets.).
9) A Metrics Server so that HPA can be implemented on cluster.
10) AWS LoadBalancer Controller for handling ingress resources (all required IAM policies, roles and service account also will be created).