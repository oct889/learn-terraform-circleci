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
  ami           = "ami-09893189de3a034b4"
  instance_type = "t2.micro"
  key_name = "deployer-key"
  subnet_id = "${aws_subnet.server1a.id}"
  vpc_security_group_ids = [aws_security_group.allow_all.id]

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

  tags = {
    Name = "Public Windows Bastion Host"
  }
}

resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMFcTdRrzL+XOpQD7bpAhE/+JZsPp7ewqufKAK05rHckTQN1iGX56ycIU4UXt4XqfKsTYSZH7yGEIdtb2TBC606HQo+UwlbcZF2dt5Wt+ENimtwQGvQPfddcR1LXPRf/5zw/X5phiSp49IUNJEP4ejAI/ZFziubt4Fbz4ipdi3W/RtneAQcXmG1OEhKKZD7w98sdOkKXZTQvVdO8kPL0j9Ud4upuQ6xGtmBy5VK4+DJg5TjearZ1ZhF9aVQuo+7VrFPeKgRKcpkJRysNlKKyZhWFwakLRmOpT111eABCcqhkUDsfy+GmH4zX0AKH84po9yDvwJVxZWUNN+fANlQW2TJN3xAknnM8XODmBUP8H8jf8shhla2jSEHG2/l1Hp0bwM52A79q5mSi8Bzynwn3hagFoYsUtfrQjGF4gkMfWCRYZzXIb2/r4xw5nq12rIcjXTX8S6422iCedlKYBqtIWblAJ+d3O+HL4TwTFxkKPo8mJOT2v9Zq0iwhcE3T7Cu+E= nicholaswinter@Nicks-FatBook-Pro.local"
}