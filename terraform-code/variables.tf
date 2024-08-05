variable "vpc_name" {
  type = string
  default = "demo-vpc"
}

variable "cluster_name" {
  type = string
  default = "demo-cluster"
}

variable "cluster_version" {
  type = number
  default = 1.29
}

#This name space should be same as in values.yaml of helm chart
variable "app_namespace" {
  type = string
  default = "test-space"
}