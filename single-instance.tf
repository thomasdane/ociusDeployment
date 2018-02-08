provider "aws" {
    region = "us-east-1"
    shared_credentials_file = "./credentials"
    profile = "ocius"
}

resource "aws_instance" "example" {
    ami = "ami-2d39803a"
    instance_type = "t2.nano"

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello world" > index.html
                nohup busybox httpd -f -p "${var.server_port}" &
                EOF

    vpc_security_group_ids = ["${aws_security_group.instance.id}"]            

    tags {
        Name = "terraform-example"
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
}

variable "server_port" {
    description = "The port the server will use for HTTP requests"
    default = 8080
}

output "public_ip" {
    value = "${aws_instance.example.public_ip}"
}