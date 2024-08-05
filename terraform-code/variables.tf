#AWS config profile name for terraform conectivity with AWS
variable "profile" {
  type = string
  default = "mj-custom"
}

#Region in which infrastructure will be provisioned
variable "region" {
  type = string
  default = "us-east-1"
}

#Public subnets for infrastructure will be provisioning
#Subnet1
variable "public-az-1a" {
  type = string
  default = "us-east-1a"
}

variable "public-az-1a-cidr" {
  type = string
  default = "10.0.64.0/19"
}

#Subnet1
variable "public-az-1b" {
  type = string
  default = "us-east-1b"
}

variable "public-az-1b-cidr" {
  type = string
  default = "10.0.96.0/19"
}

#Private subnets for infrastructure will be provisioning
#Subnet1
variable "private-az-1a" {
  type = string
  default = "us-east-1a"
}

variable "private-az-1a-cidr" {
  type = string
  default = "10.0.0.0/19"
}

#Subnet1
variable "private-az-1b" {
  type = string
  default = "us-east-1b"
}

variable "private-az-1b-cidr" {
  type = string
  default = "10.0.32.0/19"
}

#VPC name
variable "vpc_name" {
  type = string
  default = "demo-vpc"
}

#EKS Cluster Name
variable "cluster_name" {
  type = string
  default = "demo-cluster"
}

#EKS Cluster version
variable "cluster_version" {
  type = string
  default = "1.30"
}

#This name space should be same as in values.yaml of helm chart
variable "app_namespace" {
  type = string
  default = "test-space"
}

#AWS loadbalancer controller variables
variable "lb_controller_helm_version" {
  type = string
  default = "1.8.1"
}

variable "lb_controller_img_tag" {
  type = string
  default = "v2.8.1"
}

variable "lb_controller_replicaCount" {
  type = number
  default = 1
}

#Metrics server vaiables
variable "metrics_server_helm_version" {
  type = string
  default = "3.8.2"
}