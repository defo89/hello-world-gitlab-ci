resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(var.subnet_ids, count.index)}"
  count         = "${var.subnet_count}"
}

resource "aws_eip" "nat" {
  vpc   = true
  count = "${var.subnet_count}"
}
