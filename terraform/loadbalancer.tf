resource "aws_alb" "main" {
    name = "ocius-load-balancer"
    subnets = ["${aws_subnet.main.*.id}"]
    security_groups = ["${aws_security_group.lb_sg.id}"]
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = "${aws_alb.main.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.test.id}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "test" {
  name     = "tf-example-ecs-ghost"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = "${aws_autoscaling_group.example.id}"
  alb_target_group_arn   = "${aws_alb_target_group.test.arn}"
}