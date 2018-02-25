output "alb_dns_name" {
    value = "${aws_alb.example.dns_name}"
    description = "The url to view the website"
}