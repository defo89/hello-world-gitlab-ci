resource "aws_launch_configuration" "lc_web" {
  image_id                    = "${data.aws_ami.webserver.id}"
  instance_type               = "t2.micro"
  security_groups             = ["${aws_security_group.sg_web.id}"]
  associate_public_ip_address = false

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg_web" {
  name                 = "asg-app - ${aws_launch_configuration.lc_web.name}"
  launch_configuration = "${aws_launch_configuration.lc_web.name}"
  min_size             = 2
  max_size             = 4
  target_group_arns    = ["${aws_alb_target_group.alb_targets.arn}"]
  vpc_zone_identifier  = ["${aws_subnet.subnet_private_1a.id}", "${aws_subnet.subnet_private_1b.id}"]

  depends_on = ["aws_launch_configuration.lc_web"]

  lifecycle {
    create_before_destroy = true
  }
}