resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

resource "aws_route_table_association" "public1_route_table_assoc" {
  subnet_id      = aws_subnet.my_public1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public2_route_table_assoc" {
  subnet_id      = aws_subnet.my_public2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
  }

  tags = {
    Name = "RouteTablePrivada"
  }
}

resource "aws_route_table_association" "private1_route_table_assoc" {
  subnet_id      = aws_subnet.my_private1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private2_route_table_assoc" {
  subnet_id      = aws_subnet.my_private2.id
  route_table_id = aws_route_table.private_route_table.id
}