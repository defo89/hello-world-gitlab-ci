resource "aws_alb" "alb" {
  name                = "alb-web"
  internal            = false
  load_balancer_type  = "application"
  security_groups     = ["${aws_security_group.sg_elb.id}"]
  subnets             = ["${aws_subnet.subnet_public_1a.id}", "${aws_subnet.subnet_public_1b.id}"]

  tags {
    Name = "webserver-elb"
  }
}

resource "aws_alb_target_group" "alb_targets" {
  name      = "tf-lab-tg"
  port      = "80"
  protocol  = "HTTP"
  vpc_id    = "${aws_vpc.vpc_lab.id}"

  health_check {
    healthy_threshold   = 2
    interval            = 15
    path                = "/"
    timeout             = 10
    unhealthy_threshold = 2
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_targets.arn}"
    type = "forward"
  }
}