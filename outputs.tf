# Display ELB DNS name

output "elb_dns_name" {
  value = "${aws_elb.qc-elb.dns_name}"
}
