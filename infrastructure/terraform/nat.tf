# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${local.name_prefix}-nat-eip"
  }
}

# Public NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.public["eu-central-1a"].id

  tags = {
    Name = "${local.name_prefix}-nat"
  }

  depends_on = [
    aws_internet_gateway.main,
    aws_route_table_association.public
  ]
}
