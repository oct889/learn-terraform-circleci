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

# # VV might all be unnecessary if I can get the VPC endpoint for the private subnets working

# # this gets a bunch of information into TF, including directoryID, directoryName, dnsIpAddresses
# data "aws_directory_service_directory" "my_domain_controller" {
#   directory_id = aws_directory_service_directory.terra_ad.id
# }

# # not sure how useful this is, i don't want to set dhcp options
# resource "aws_vpc_dhcp_options" "ad" {
#   domain_name          = "terra.com"
#   domain_name_servers  = ["AmazonProvidedDNS"]

#   tags = {
#     Name = "ActiveDirectory"
#   }
# }

# # not sure how useful this is
# resource "aws_vpc_dhcp_options_association" "ad" {
#   vpc_id          = aws_vpc.prod_vpc.id
#   dhcp_options_id = "${aws_vpc_dhcp_options.ad.id}"
# }