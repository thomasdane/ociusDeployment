resource "aws_launch_configuration" "wordpress" {
    image_id = "ami-2d39803a"
    instance_type = "t2.nano"
    security_groups = ["${aws_security_group.instance.id}"]

    user_data = <<-EOF
              #!/bin/bash
              echo "Wordpress site" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

    lifecycle {
        create_before_destroy = true
    }
}