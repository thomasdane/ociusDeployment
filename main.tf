provider "aws" {
  region  = "ap-southeast-1"
  profile = "ocius"
}

data "aws_availability_zones" "all" {}

resource "aws_launch_configuration" "tracker" {
  image_id        = "ami-35663649"
  instance_type   = "t2.nano"
  security_groups = ["${aws_security_group.instance.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-tracker-instance"

  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "tracker" {
  launch_configuration = "${aws_launch_configuration.tracker.id}"
  availability_zones   = ["${data.aws_availability_zones.all.names}"]

  min_size = 1
  max_size = 3

  load_balancers    = ["${aws_elb.tracker.name}"]
  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "terraform-asg-tracker"
    propagate_at_launch = true
  }
}

resource "aws_elb" "tracker" {
  name               = "terraform-asg-tracker"
  security_groups    = ["${aws_security_group.elb.id}"]
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "${var.server_port}"
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:${var.server_port}/"
  }
}

resource "aws_security_group" "elb" {
  name = "terraform-tracker-elb"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 80
}

output "elb_dns_name" {
  value = "${aws_elb.tracker.dns_name}"
}
