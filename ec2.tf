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

# data "aws_ami" "windows" {
#      most_recent = true     
#  filter {
#        name   = "name"
#        values = ["Windows_Server-2019-English-Full-Base-*"]  
#   }     
#  filter {
#        name   = "virtualization-type"
#        values = ["hvm"]  
#   }   

#  owners = ["801119661308"] # Canonical
# }

resource "aws_instance" "bastion_host" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "deployer-key"
  subnet_id = "${aws_subnet.public1a.id}"
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.id}"

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
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.id}"

  tags = {
    Name = var.instance_name
  }
}

resource "aws_instance" "private_windows" {
  ami           = "ami-09893189de3a034b4"
  instance_type = "t2.micro"
  key_name = "deployer-key"
  subnet_id = "${aws_subnet.server1a.id}"
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.id}"

  tags = {
    Name = "Private Windows DC"
  }
}

resource "aws_instance" "public_windows_bastion_host" {
  ami           = "ami-09893189de3a034b4"
  instance_type = "t2.micro"
  key_name = "deployer-key"
  subnet_id = "${aws_subnet.public1a.id}"
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.id}"

  tags = {
    Name = "Public Windows Bastion Host"
  }
}

resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCyyc3JV2cpEWu5jBloCUDHv31Ix7ETI3OsSRNtQWzY1DLBeXLBSBZSPYAc/ZX+T59U9FtnE+ozly+I+PUbX67xD72CZoOyXsFpXn1v6ZoTamiZD/4DfObJmQrBpT66lg2NnBHC1rjc/+Jp50NxceyLzHG2JHzY/cSu53frnZ2tsVMhfhdRf8Oyu2BzTnToa58DGduiOHwF9uzcFh2jzriTaAX3/JVUQqUXv1Epa2i9Kdbg+6p0+zaE9rPRuPKc5KAJGbzQTThjLxKHuKcucL3FGFHAvmZWLpcm9RQZqo043F8P5xV+CgP326vn+U3tj1uw16urCJcUvyOqeyNb1Hd+spdxJiMYj2K9ilGfywAyIYfUVyL4dTLEZZ8t60nSI72OAxpPtKUoWVGUALv0/FrN5M3zl10iv5fxNN4y9DIRUFmziZ8te764WkNwSzH0YcH6a6eujVBz6M+tFutDLFyHubWV1JRKPQH6WP4bbqyRBio7JExz9qvFCMGJvO6UFk= nicholaswinter@Nicks-FatBook-Pro.local"
}