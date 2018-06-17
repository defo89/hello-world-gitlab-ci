resource "aws_launch_configuration" "launch_config" {
  image_id                    = "${data.aws_ami.webserver.id}"
  instance_type               = "${var.instance_type}"
  security_groups             = ["${aws_security_group.web.id}"]
  associate_public_ip_address = false
  key_name                    = "${var.key_name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                 = "asg-app - ${aws_launch_configuration.launch_config.name}"
  launch_configuration = "${aws_launch_configuration.launch_config.name}"
  min_size             = "${var.min_size}"
  max_size             = "${var.max_size}"
  target_group_arns    = ["${var.target_group}"]
  vpc_zone_identifier  = ["${var.private_subnet_ids}"]

  depends_on = ["aws_launch_configuration.launch_config"]

  lifecycle {
    create_before_destroy = true
  }
}

# Create security group to access instances
resource "aws_security_group" "web" {
  name        = "sg_webserver"
  description = "security group for web servers"
  vpc_id      = "${var.vpc_id}"

  # HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${var.sg_bastion}"]
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # allow all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}
