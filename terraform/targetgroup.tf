resource "aws_alb_target_group" "wordpress" {
    name = "wordpress"
    port = 80
    protocol = "HTTP"
    vpc_id = "${aws_vpc.main.id}"
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
}

# resource "aws_lb_target_group_attachement" "test" {
#     target_group_arn = "${aws_alb_target_group.wordpress.arn}"
#     target_id = "${aws_security_group.instance.id}"
# }