resource "aws_elb" "example" {
    name = "terraform-asg-example"
    security_groups = ["${aws_security_group.elb.id}"]
    availability_zones = ["${data.aws_availability_zones.all.names}"]

    listener {
        lb_port = 80
        lb_protocol = "http"
        instance_port = "${var.server_port}"
        instance_protocol = "http"
    }

    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        interval = 30
        target = "HTTP:${var.server_port}/"
    }
}

resource "aws_alb_listener" "ocius" {
    load_balancer_arn = "${aws_elb.example.arn}"
    port = "80"
    protocol = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.wordpress.arn}"
        type = "forward"
    }
}

resource "aws_alb_listener_rule" "wordpress" {
    listener_arn = "${aws_alb_listener.ocius.arn}"
    priority = 99

    action {
        type = "forward"
        target_group_arn = "${aws_alb_target_group.wordpress.arn}"
    }

    condition {
        field = "host-header"
        values = ["ocius.com"]
    }
}