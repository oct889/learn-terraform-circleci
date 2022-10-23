resource "aws_directory_service_directory" "terra_ad" {
  name     = "terra.com"
  password = "SuperSecretPassw0rd"
  edition  = "Standard"
  type     = "MicrosoftAD"

  vpc_settings {
    vpc_id     = aws_vpc.prod_vpc.id
    subnet_ids = [aws_subnet.server1a.id, aws_subnet.server1b.id]
  }

  tags = {
    Project = "foo"
  }
}

resource "aws_vpc_dhcp_options" "ad" {
  domain_name          = "terra.com"
  domain_name_servers  = ["AmazonProvidedDNS"]

  tags {
    Name = "ActiveDirectory"
  }
}

resource "aws_vpc_dhcp_options_association" "ad" {
  vpc_id          = aws_vpc.prod_vpc.id
  dhcp_options_id = "${aws_vpc_dhcp_options.ad.id}"
}