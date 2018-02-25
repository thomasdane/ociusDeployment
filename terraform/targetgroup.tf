resource "aws_alb_target_group" "wordpress" {
    name = "wordpress"
    port = 80
    protocol = "HTTP"
    vpc_id = "${aws_vpc.main.id}"
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.0.0/24"
}

resource "aws_autoscaling_attachment" "wordpress" {
    alb_target_group_arn = "${aws_alb_target_group.wordpress.arn}"
    autoscaling_group_name = "${aws_autoscaling_group.example.id}"
}