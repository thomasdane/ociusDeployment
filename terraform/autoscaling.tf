resource "aws_autoscaling_group" "example" {
    launch_configuration = "${aws_launch_configuration.example.id}"
    availability_zones = ["${data.aws_availability_zones.available.names}"]

    min_size = 1
    max_size = 1

    load_balancers = ["${aws_alb.example.name}"]
    health_check_type = "ELB"

    tag {
        key = "Name"
        value = "terraform-asg-example"
        propagate_at_launch = true
    }
}
