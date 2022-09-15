provider "aws" {
  region = var.region

  default_tags {
    tags = {
      hashicorp-learn = "circleci"
    }
  }
}

resource "random_uuid" "randomid" {}

resource "aws_vpc" "prod_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "Terra VPC"
  }
}

resource "aws_subnet" "server1a" {
  vpc_id = aws_vpc.prod_vpc.id
  cidr_block = "10.0.10.0/24"

  tags = {
    Name = "Server 1a"
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
    cidr_block = "10.0.20.0/24"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra_igw.id
  }

  tags = {
    Name = "Public 1a Route Table"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "deployer-key"
  subnet_id = "${aws_subnet.public1a.id}"
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  tags = {
    Name = var.instance_name
  }
}

resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHpVbdd3Mbzz5Uf9hwQaERDPw1bkCicJ5RKsrsE43qBG contact@nicholaswinter.com"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.prod_vpc.id}"

  ingress {
    description      = "allow all from internet"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_all"
  }
}