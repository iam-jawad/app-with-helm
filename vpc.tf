resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = var.vpc_name
  }
}

#Public subnets

resource "aws_subnet" "public-az-1a" {
  vpc_id                  = aws_vpc.demo-vpc.id
  cidr_block              = var.public-az-1a-cidr
  availability_zone       = var.public-az-1a
  #This indicates that instances launched into this subnet will automatically receive a public IP address.
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "public-${var.public-az-1a}"
    #This tag is used by Kubernetes to identify the subnet for internal load balancers
    "kubernetes.io/role/elb"                    = "1"
    #This tag is used by Kubernetes to identify resources that belong to a specific cluster
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "public-az-1b" {
  vpc_id                  = aws_vpc.demo-vpc.id
  cidr_block              = var.public-az-1b-cidr
  availability_zone       = var.public-az-1b
  #This indicates that instances launched into this subnet will automatically receive a public IP address.
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "public-${var.public-az-1b}"
    #This tag is used by Kubernetes to identify the subnet for internal load balancers
    "kubernetes.io/role/elb"                    = "1"
    #This tag is used by Kubernetes to identify resources that belong to a specific cluster
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

#Private subnets

resource "aws_subnet" "private-az-1a" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = var.private-az-1a-cidr
  availability_zone = var.private-az-1a

  tags = {
    "Name"                                      = "private-${var.private-az-1a}"
    #This tag is used by Kubernetes to identify the subnet for internal load balancers
    "kubernetes.io/role/internal-elb"           = "1"
    #This tag is used by Kubernetes to identify resources that belong to a specific cluster
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "private-az-1b" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = var.private-az-1b-cidr
  availability_zone = var.private-az-1b

  tags = {
    "Name"                                      = "private-${var.private-az-1b}"
    #This tag is used by Kubernetes to identify the subnet for internal load balancers
    "kubernetes.io/role/internal-elb"           = "1"
    #This tag is used by Kubernetes to identify resources that belong to a specific cluster
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}