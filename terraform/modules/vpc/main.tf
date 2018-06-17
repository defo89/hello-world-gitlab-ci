resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = true

  tags {
    Name        = "${var.environment}"
    Environment = "${var.environment}"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Environment = "${var.environment}"
  }
}
