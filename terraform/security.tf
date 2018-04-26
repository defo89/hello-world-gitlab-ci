# Create security group to access instances
resource "aws_security_group" "sg_web" {
  name        = "sg_lab_webserver"
  description = "security group for public instances"
  vpc_id      = "${aws_vpc.vpc_lab.id}"

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # allow all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# elb security group to access the ELB over HTTP
resource "aws_security_group" "sg_elb" {
  name        = "elb_sg"
  description = "managed by terraform - ELB SG"

  vpc_id = "${aws_vpc.vpc_lab.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
