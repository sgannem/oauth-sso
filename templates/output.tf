output "Elastic_ip_id" {
  description = "Elastic IP address attached to Fargate"
  value       = aws_eip.sso_auth_server_elastic_ip.id
}

output "Elastic_ip_address" {
  description = "Elastic IP address attached to Fargate"
  value       = aws_eip.sso_auth_server_elastic_ip.public_ip
}