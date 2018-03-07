// Security group for the instances
resource "aws_security_group" "instance" {
    name = "terraform-example-instance"
    vpc_id      = "${aws_vpc.main.id}"

    ingress {
        from_port = "${var.server_port}"
        to_port = "${var.server_port}"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        security_groups = [
            "${aws_security_group.lb_sg.id}",
        ]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle {
        create_before_destroy = true
    }
}

// Security group for the load balancer
resource "aws_security_group" "lb_sg" {
  vpc_id = "${aws_vpc.main.id}"
  name   = "alb-security-group"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}
