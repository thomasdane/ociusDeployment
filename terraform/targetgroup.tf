resource "aws_alb_target_group" "wordpress" {
    name = "wordpress"
    port = 80
    protocol = "HTTP"
    vpc_id = "${aws_vpc.main.id}"
}

resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.main.id}"
    tags {
        Name = "igw"
    }
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
    count                   = 2
    vpc_id                  = "${aws_vpc.main.id}"
    cidr_block              = "10.0.${count.index}.0/24"
    depends_on = [
        "aws_internet_gateway.igw"
    ]
}

resource "aws_autoscaling_attachment" "wordpress" {
    alb_target_group_arn = "${aws_alb_target_group.wordpress.arn}"
    autoscaling_group_name = "${aws_autoscaling_group.example.id}"
}