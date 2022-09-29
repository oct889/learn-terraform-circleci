output "private_ips" {
  value = aws_instance.bastion_host.private_ip
}

output "public_ips" {
  value = aws_instance.web.public_ip
}

output "private_ips" {
  value = aws_instance.private_host.private_ip
}

output "public_ips" {
  value = aws_instance.private_host.public_ip
}