resource "aws_vpc" "vpc_lab" {
  cidr_block = "10.10.0.0/16"
}

# Create an internet gateway
resource "aws_internet_gateway" "igw_lab" {
  vpc_id = "${aws_vpc.vpc_lab.id}"
}

resource "aws_eip" "eip_nat_gw" {
  vpc      = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.eip_nat_gw.id}"
  subnet_id     = "${aws_subnet.subnet_public_1b.id}"

  depends_on = ["aws_internet_gateway.igw_lab"]
}

# Create route table for public subnets
resource "aws_route_table" "rt_public" {
  vpc_id = "${aws_vpc.vpc_lab.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw_lab.id}"
  }
}

# Create route table for private subnets
resource "aws_route_table" "rt_private" {
  vpc_id = "${aws_vpc.vpc_lab.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat_gw.id}"
  }
}

# Create public subnet 1
resource "aws_subnet" "subnet_public_1a" {
  vpc_id                  = "${aws_vpc.vpc_lab.id}"
  cidr_block              = "10.10.20.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags {
    name = "Public Subnet 1a"
  }
}

# Create public subnet 2
resource "aws_subnet" "subnet_public_1b" {
  vpc_id                  = "${aws_vpc.vpc_lab.id}"
  cidr_block              = "10.10.21.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true

  tags {
    name = "Public Subnet 1b"
  }
}

# Create private subnet 1
resource "aws_subnet" "subnet_private_1a" {
  vpc_id            = "${aws_vpc.vpc_lab.id}"
  cidr_block        = "10.10.30.0/24"
  availability_zone = "eu-west-1a"

  tags {
    name = "Private Subnet 1a"
  }
}

# Create private subnet 2
resource "aws_subnet" "subnet_private_1b" {
  vpc_id            = "${aws_vpc.vpc_lab.id}"
  cidr_block        = "10.10.31.0/24"
  availability_zone = "eu-west-1b"

  tags {
    name = "Private Subnet 1b"
  }
} 

# associate route tables with subnets
resource "aws_route_table_association" "rtassoc_public_1a" {
  subnet_id      = "${aws_subnet.subnet_public_1a.id}"
  route_table_id = "${aws_route_table.rt_public.id}"
}

resource "aws_route_table_association" "rtassoc_public_1b" {
  subnet_id      = "${aws_subnet.subnet_public_1b.id}"
  route_table_id = "${aws_route_table.rt_public.id}"
}

resource "aws_route_table_association" "rtassoc_private_1a" {
  subnet_id      = "${aws_subnet.subnet_private_1a.id}"
  route_table_id = "${aws_route_table.rt_private.id}"
}

resource "aws_route_table_association" "rtassoc_private_1b" {
  subnet_id      = "${aws_subnet.subnet_private_1b.id}"
  route_table_id = "${aws_route_table.rt_private.id}"
}