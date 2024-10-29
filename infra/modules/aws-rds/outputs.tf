output "RdsInstanceIp" {
  value = aws_db_instance.this.address
}

output "RdsInstanceFQDN" {
  value = aws_db_instance.this.domain_fqdn
}