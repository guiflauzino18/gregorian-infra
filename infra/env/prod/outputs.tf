output "RdsInstanceIp" {
  value = aws_db_instance.this.address
}

output "LoadbalancerDns" {
  value = aws_lb.this.dns_name
}

output "userData" {
  value = local_file.userData.content
}