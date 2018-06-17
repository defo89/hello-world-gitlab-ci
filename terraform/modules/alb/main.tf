resource "aws_alb" "default" {
  name               = "${var.alb_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb.id}"]
  subnets            = ["${var.public_subnet_ids}"]

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_alb_target_group" "default" {
  name     = "tf-lab-tg"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    healthy_threshold   = 2
    interval            = 15
    path                = "/"
    timeout             = 10
    unhealthy_threshold = 2
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = "${aws_alb.default.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.arn}"
    type             = "forward"
  }
}

# elb security group to access the ELB over HTTP
resource "aws_security_group" "alb" {
  name        = "elb_sg"
  description = "managed by terraform - ALB SG"
  vpc_id      = "${var.vpc_id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.allow_cidr_block}"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
