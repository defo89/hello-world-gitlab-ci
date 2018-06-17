# Output ALB DNS Name
output "ALB DNS Name" {
  value = "${module.alb.dns}"
}

output "Bastion DNS Name" {
  value = "${module.bastion.dns}"
}
