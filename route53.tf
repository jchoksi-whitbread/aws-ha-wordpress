data "aws_route53_zone" "selected" {
  name         = "${var.dnsname}"
}

resource "aws_route53_record" "hawordpress" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "hawordpress.${data.aws_route53_zone.selected.name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_alb.hawordpress.dns_name}"]
}