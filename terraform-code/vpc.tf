resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = var.cluster_name
  }
}

resource "aws_subnet" "public-us-east-1a" {
  vpc_id                  = aws_vpc.demo-vpc.id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = "us-east-1a"
  #This indicates that instances launched into this subnet will automatically receive a public IP address.
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "public-us-east-1a"
    #This tag is used by Kubernetes to identify the subnet for internal load balancers
    "kubernetes.io/role/elb"                    = "1"
    #This tag is used by Kubernetes to identify resources that belong to a specific cluster
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "private-us-east-1b" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = "us-east-1b"

  tags = {
    "Name"                                      = "private-us-east-1b"
    #This tag is used by Kubernetes to identify the subnet for internal load balancers
    "kubernetes.io/role/internal-elb"           = "1"
    #This tag is used by Kubernetes to identify resources that belong to a specific cluster
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}