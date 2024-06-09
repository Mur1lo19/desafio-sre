resource "aws_vpc" "my_vpc" {
  cidr_block = "10.10.0.0/16"
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_eip" "nat_gateway_ip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.nat_gateway_ip.id
  subnet_id     = aws_subnet.my_public1.id
}

resource "aws_subnet" "my_public1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.10.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "my_public2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.10.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-2b"
}

resource "aws_subnet" "my_private1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.10.3.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "my_private2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.10.4.0/24"
  availability_zone = "us-east-2b"
}

resource "aws_subnet" "my_private_db1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.10.5.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "my_private_db2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.10.6.0/24"
  availability_zone = "us-east-2b"
}

resource "aws_security_group" "lb_sg" {
  name        = "lb-sg"
  description = "Allow traffic in my-app"
  vpc_id      = aws_vpc.my_vpc.id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["10.10.0.0/16"]
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow traffic in my-app"
  vpc_id      = aws_vpc.my_vpc.id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["10.10.0.0/16"]
  }
}