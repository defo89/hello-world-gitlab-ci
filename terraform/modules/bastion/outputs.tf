output "sg_id" {
  value = "${aws_security_group.bastion.id}"
}

output "dns" {
  value = "${aws_instance.bastion.public_dns}"
}
