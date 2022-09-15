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

  tags = {
    Name = "Server 1a"
  }
}

resource "aws_route_table_association" "server1a_rt_assoc" {
  subnet_id = aws_subnet.server1a.id
  route_table_id = aws_route_table.server1a_rt.id
}

resource "aws_route_table" "server1a_rt" {
  vpc_id = aws_vpc.prod_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.terra_igw.id
#   }

  tags = {
    Name = "Server 1a Route Table"
  }
}