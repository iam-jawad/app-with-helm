#Gateways
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "internetGateway"
  }
}

resource "aws_eip" "nat-eip" {
  domain = "vpc"

  tags = {
    Name = "natGateway-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public-us-east-1a.id

  tags = {
    Name = "natGateway"
  }

  depends_on = [aws_internet_gateway.igw]
}

#Routes and route tables

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.demo-vpc.id

  #This block defines a routing rule within the route table.
  route {
    #This specifies that the route applies to all IP addresses 
    cidr_block     = "0.0.0.0/0"
    #This specifies that traffic matching the CIDR block (0.0.0.0/0) should be routed through the NAT Gateway.
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.demo-vpc.id
  
  #This block defines a routing rule within the route table.
  route {
    #This specifies that the route applies to all IP addresses 
    cidr_block = "0.0.0.0/0"
    #This specifies that traffic matching the CIDR block (0.0.0.0/0) should be routed through the NAT Gateway.
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "public-us-east-1a" {
  subnet_id      = aws_subnet.public-us-east-1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private-us-east-1b" {
  subnet_id      = aws_subnet.private-us-east-1b.id
  route_table_id = aws_route_table.private.id
}