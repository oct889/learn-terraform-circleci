resource "aws_vpc" "prod_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    "Name" = "Terra VPC"
  }
}

resource "aws_internet_gateway" "terra_igw" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name = "terra_igw"
  }
}

resource "aws_subnet" "public1a" {
  vpc_id = aws_vpc.prod_vpc.id
  cidr_block = "10.0.20.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public 1a"
  }
}

resource "aws_route_table_association" "public1a_rt_assoc" {
  subnet_id = aws_subnet.public1a.id
  route_table_id = aws_route_table.public1a_rt.id
}

resource "aws_route_table" "public1a_rt" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra_igw.id
  }

  tags = {
    Name = "Public 1a Route Table"
  }
}

resource "aws_subnet" "server1a" {
  vpc_id = aws_vpc.prod_vpc.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Server 1a"
  }
}

resource "aws_subnet" "server1b" {
  vpc_id = aws_vpc.prod_vpc.id
  cidr_block = "10.0.11.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Server 1b"
  }
}

resource "aws_eip" "nat_eip" {
  vpc      = true
}

resource "aws_nat_gateway" "terra_nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public1a.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.terra_igw]
}

resource "aws_route_table_association" "server1a_rt_assoc" {
  subnet_id = aws_subnet.server1a.id
  route_table_id = aws_route_table.server1a_rt.id
}

resource "aws_route_table" "server1a_rt" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.terra_nat_gateway.id
  }

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.terra_igw.id
#   }

  tags = {
    Name = "Server 1a Route Table"
  }
}