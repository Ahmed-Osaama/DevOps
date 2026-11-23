# Public Subnets
resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name = "${local.name_prefix}-public-${each.key}"

    "kubernetes.io/role/elb" = "1"

    "kubernetes.io/cluster/${local.name_prefix}-eks" = "shared"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name = "${local.name_prefix}-private-${each.key}"

    "kubernetes.io/role/internal-elb" = "1"

    "kubernetes.io/cluster/${local.name_prefix}-eks" = "shared"
  }
}
