
resource "aws_vpc" "gitlab" {
  cidr_block            = "10.0.0.0/16" // TODO: Is it ok to hardcode cird blocks or better to extract them to a variables?
  enable_dns_support    = true
  enable_dns_hostnames  = true

  tags = {
    Name = "GitLab"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.gitlab.id

  tags = {
    Name = "Gitlab"
  }
}

resource "aws_subnet" "public" {
  cidr_block        = "10.0.0.0/24"
  vpc_id            = aws_vpc.gitlab.id
  availability_zone = "eu-central-1b"

  tags = {
    Name = "Gitlab Public"
  }
}

resource "aws_subnet" "private" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.gitlab.id
  availability_zone = "eu-central-1b"

  tags = {
    Name = "Gitlab Private"
  }
}

// TODO: Investigate how to improve all that copypast
resource "aws_subnet" "rds1" {
  availability_zone = "${var.region}a"
  cidr_block = "10.0.10.0/24"
  vpc_id = aws_vpc.gitlab.id

  tags = {
    Name = "Gitlab Private for RDSs"
  }
}

resource "aws_subnet" "rds2" {
  availability_zone = "${var.region}b"
  cidr_block = "10.0.11.0/24"
  vpc_id = aws_vpc.gitlab.id

  tags = {
    Name = "Gitlab Private for RDSs"
  }
}

resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "GitLab EIP for NAT GW"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public.id

  tags = {
    Name = "GitLab"
  }
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.gitlab.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "GitLab default"
  }
}

resource "aws_route_table" "internet" {
  vpc_id = aws_vpc.gitlab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "GitLab"
  }
}

resource "aws_route_table_association" "internet" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.internet.id
}
