output "bastion_private_ips" {
  value = aws_instance.bastion_host.private_ip
}

output "bastion_public_ips" {
  value = aws_instance.bastion_host.public_ip
}

output "server_private_ips" {
  value = aws_instance.private_host.private_ip
}

output "server_public_ips" {
  value = aws_instance.private_host.public_ip
}

output "ad_dns_addresses" {
  value = aws_directory_service_directory.terra_ad.dns_ip_addresses
}