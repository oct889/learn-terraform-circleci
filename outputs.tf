output "endpoint" {
  value = "${aws_s3_bucket.app.bucket_domain_name}/index.html"
}

output "private_ips" {
  value = aws_instance.web.private_ip
}