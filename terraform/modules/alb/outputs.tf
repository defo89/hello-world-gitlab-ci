output "dns" {
  value = "${aws_alb.default.dns_name}"
}

output "target_group" {
  value = "${aws_alb_target_group.default.arn}"
}
