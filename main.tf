resource "aws_launch_configuration" "example" {
    image_id = "ami-2d39803a"
    instance_type = "t2.nano"
    security_groups = ["${aws_security_group.instance.id}"]

    user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_security_group" "instance" {
    name = "terraform-example-instance"

    ingress {
        from_port = "${var.server_port}"
        to_port = "${var.server_port}"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "example" {
    launch_configuration = "${aws_launch_configuration.example.id}"
    availability_zones = ["${data.aws_availability_zones.all.names}"]

    min_size = 1
    max_size = 1

    tag {
        key = "Name"
        value = "terraform-asg-example"
        propagate_at_launch = true
    }
}

resource "aws_elb" "example" {
    name = "terraform-asg-example"
    availability_zones = ["${data.aws_availability_zones.all.names}"]

    listener {
        lb_port = 80
        lb_protocol = "http"
        instance_port = "${var.server_port}"
        instance_protocol = "http"
    }
}

resource "aws_security_group" "elb" {
    name = "terraform-example-elb"

    ingress
}