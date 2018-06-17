variable "subnet_ids" {
  type        = "list"
  description = "List of subnets in which to place the NAT Gateway"
}

variable "subnet_count" {
  description = "Size of the subnet_ids. This needs to be provided because: value of 'count' cannot be computed"
}

variable "vpc_id" {
  description = "VPC id to place to subnet into"
}
