resource "random_uuid" "randomid" {}

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

data "aws_ami" "windows" {
     most_recent = true     
 filter {
       name   = "name"
       values = ["Windows_Server-2019-English-Full-Base-*"]  
  }     
 filter {
       name   = "virtualization-type"
       values = ["hvm"]  
  }   

 owners = ["801119661308"] # Canonical
}

resource "aws_instance" "bastion_host" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "deployer-key"
  subnet_id = "${aws_subnet.public1a.id}"
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  tags = {
    Name = var.instance_name
  }
}

resource "aws_instance" "private_host" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "deployer-key"
  subnet_id = "${aws_subnet.server1a.id}"
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  tags = {
    Name = var.instance_name
  }
}

resource "aws_instance" "private_windows" {
  ami           = data.aws_ami.windows.id
  instance_type = "t2.micro"
  key_name = "deployer-key"
  subnet_id = "${aws_subnet.server1a.id}"
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  tags = {
    Name = "Private Windows DC"
  }
}

resource "aws_instance" "public_windows_bastion_host" {
  ami           = data.aws_ami.windows.id
  instance_type = "t2.micro"
  key_name = "deployer-key"
  subnet_id = "${aws_subnet.public1a.id}"
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  tags = {
    Name = "Public Windows Bastion Host"
  }
}

resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHpVbdd3Mbzz5Uf9hwQaERDPw1bkCicJ5RKsrsE43qBG contact@nicholaswinter.com"
}