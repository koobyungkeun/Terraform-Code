# vpc 생성
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = var.name
  }
}

# 2개 az에 public subnet 1개씩 생성
resource "aws_subnet" "public_subnet" {
  count                   = length(var.pub_cidr)
  vpc_id                  = aws_vpc.main.id
  availability_zone       = var.azs[count.index]
  cidr_block              = var.pub_cidr[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                                            = "${var.name}_public_subnet_${var.azs[count.index]}"
    "kubernetes.io/cluster/${var.name}_eks_cluster" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  }
}

# 2개 az에 private subnet 1개씩 생성
resource "aws_subnet" "private_subnet" {
  count             = length(var.pri_cidr)
  vpc_id            = aws_vpc.main.id
  availability_zone = var.azs[count.index]
  cidr_block        = var.pri_cidr[count.index]

  tags = {
    Name                                            = "${var.name}_private_subnet_${var.azs[count.index]}"
    "kubernetes.io/cluster/${var.name}_eks_cluster" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  }
}

# 2개 az에 private subnet2 1개씩 생성
resource "aws_subnet" "private_subnet2" {
  count             = length(var.pri_cidr2)
  vpc_id            = aws_vpc.main.id
  availability_zone = var.azs[count.index]
  cidr_block        = var.pri_cidr2[count.index]

  tags = {
    Name                                            = "${var.name}_private_subnet2_${var.azs[count.index]}"
    "kubernetes.io/cluster/${var.name}_eks_cluster" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  }
}

# igw 생성
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}_main_vpc_igw"
  }
}

# 각 az의 public subnet에 ngw 생성
resource "aws_nat_gateway" "ngw" {
  count         = length(var.azs)
  allocation_id = aws_eip.ngw_eip.*.id[count.index]
  subnet_id     = aws_subnet.public_subnet.*.id[count.index]

  tags = {
    Name = "${var.name}_main_vpc_ngw_${var.azs[count.index]}"
  }
}

# ngw에 할당할 eip 생성
resource "aws_eip" "ngw_eip" {
  count = length(var.azs)
  vpc   = true

  tags = {
    Name = "${var.name}_main_vpc_ngw_eip_${var.azs[count.index]}"
  }
}

# public route table 생성
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name}_public_route_table"
  }
}

# private route table 생성
resource "aws_route_table" "private_route_table" {
  count  = length(var.azs)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.*.id[count.index]
  }

  tags = {
    Name = "${var.name}_private_route_table_${var.azs[count.index]}"
  }
}

# public route table - 각 az public subnet 연동
resource "aws_route_table_association" "public_subnet_route" {
  count          = length(var.pub_cidr)
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_route_table.id
}

# private route table - 각 az private subnet 연동
resource "aws_route_table_association" "private_subnet_route" {
  count          = length(var.pri_cidr)
  subnet_id      = aws_subnet.private_subnet.*.id[count.index]
  route_table_id = aws_route_table.private_route_table.*.id[count.index]
}

# private route table - 각 az private subnet2 연동
resource "aws_route_table_association" "private_subnet2_route" {
  count          = length(var.pri_cidr2)
  subnet_id      = aws_subnet.private_subnet2.*.id[count.index]
  route_table_id = aws_route_table.private_route_table.*.id[count.index]
}
