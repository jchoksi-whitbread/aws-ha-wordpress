# Create a new load balancer
resource "aws_alb" "hawordpress" {
  name            = "wordpress-alb"
  internal        = false
  security_groups = ["${aws_security_group.web.id}"]
  subnets         = ["${aws_default_subnet.default_az1.id}","${aws_default_subnet.default_az2.id}","${aws_default_subnet.default_az3.id}"]
  enable_deletion_protection = true
}

resource "aws_alb_target_group" "hawordpress" {
  name     = "wordpress-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_default_vpc.default.id}"

  stickiness {
    type             = "lb_cookie"
  }
}

resource "aws_alb_listener" "hawordpress" {
  load_balancer_arn = "${aws_alb.hawordpress.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.hawordpress.arn}"
    type             = "forward"
  }
}