output "id" {
  value = "${aws_vpc.vpc.id}"
}

output "igw" {
  value = "${aws_internet_gateway.igw.id}"
}
