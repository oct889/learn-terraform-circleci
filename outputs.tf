output "private_ips" {
  value = aws_instance.web.private_ip
}

output "public_ips" {
  value = aws_instance.web.public_ip
}