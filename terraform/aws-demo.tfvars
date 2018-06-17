vpc_cidr = "10.172.0.0/16"

environment = "dev"

public_subnet_cidrs = ["10.172.1.0/24", "10.172.2.0/24"]

private_subnet_cidrs = ["10.172.81.0/24", "10.172.82.0/24"]

availability_zones = ["eu-west-1a", "eu-west-1b"]

max_size = 4

min_size = 2

instance_type = "t2.micro"
