resource "aws_directory_service_directory" "terra_ad" {
  name     = "corp.notexample.com"
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