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

variable "sg_bastion" {
  description = "Bastion host Security Group ID"
}

variable "max_size" {
  description = "Max EC2 instance count in the auto-scaling group"
}

variable "min_size" {
  description = "Min EC2 instance count in the auto-scaling group"
}

variable "private_subnet_ids" {
  type        = "list"
  description = "List of private subnet IDs"
}

variable "target_group" {
  description = "Target group ARN"
}
