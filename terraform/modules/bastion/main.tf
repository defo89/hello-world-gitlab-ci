resource "aws_instance" "bastion" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  vpc_security_group_ids      = ["${aws_security_group.bastion.id}"]
  key_name                    = "${var.key_name}"
  subnet_id                   = "${var.public_subnet_ids[0]}"
  associate_public_ip_address = true

  tags {
    Environment = "${var.environment}"
  }
}

# Create security group to access instances
resource "aws_security_group" "bastion" {
  name        = "sg_bastion"
  description = "security group for bastion host"
  vpc_id      = "${var.vpc_id}"

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # allow all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}
