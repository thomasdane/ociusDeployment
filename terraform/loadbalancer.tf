resource "aws_alb" "example" {
    name = "terraform-asg-example"
    internal = false
    security_groups = ["${aws_security_group.alb.id}"]
    subnets = ["${aws_subnet.subnet.*.id}"]
}

resource "aws_alb_listener" "ocius" {
    load_balancer_arn = "${aws_alb.example.arn}"
    port = "80"
    protocol = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.wordpress.arn}"
        type = "forward"
    }
}

resource "aws_alb_listener_rule" "wordpress" {
    depends_on = ["aws_alb_target_group.wordpress"]
    listener_arn = "${aws_alb_listener.ocius.arn}"
    priority = 99

    action {
        type = "forward"
        target_group_arn = "${aws_alb_target_group.wordpress.arn}"
    }

    condition {
        field = "path-pattern"
        values = ["/wordpress"]
    }
}