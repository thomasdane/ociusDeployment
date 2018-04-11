data "aws_acm_certificate" "ocius-cloud" {
  domain   = "*.ocius.cloud"
  statuses = ["ISSUED"]
}

# resource "aws_route53_record" "tracking" {
#   depends_on = ["aws_elb.tracker"]
#   zone_id    = "${data.terraform_remote_state.dns.public_hosted_zone_id}"
#   name       = "${var.service}-cms-standby"
#   type       = "A"


#   alias {
#     name                   = "${aws_alb.cms.dns_name}"
#     zone_id                = "${aws_alb.cms.zone_id}"
#     evaluate_target_health = true
#   }
# }

