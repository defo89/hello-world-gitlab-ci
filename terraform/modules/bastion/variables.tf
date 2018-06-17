variable "environment" {
  description = "The name of the environment"
}

variable "vpc_id" {
  description = "VPC id to place to subnet into"
}

variable "instance_type" {
  description = "EC2 instance type"
}

variable "key_name" {
  description = "SSH key name to be used"
}

variable "public_subnet_ids" {
  type        = "list"
  description = "List of public subnet IDs"
}
