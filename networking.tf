resource "aws_internet_gateway" "terra_igw" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name = "terra_igw"
  }
}