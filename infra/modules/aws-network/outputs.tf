output "subnet1-id" {
  value = aws_subnet.sub1.id
}
output "subnet2-id" {
  value = aws_subnet.sub2.id
}
output "subnet3-id" {
  value = aws_subnet.sub3.id
}
output "vpc-id" {
  value = aws_vpc.this.id
}
output "SGForRDS" {
  value = aws_security_group.SG_RDS.id
}

output "SGForAPIInstances" {
  value = aws_security_group.SG_API.id
}

output "SGNameForRDS" {
  value = aws_security_group.SG_RDS.id
}
output "SGNameForAPIInstances" {
  value = aws_security_group.SG_API.name
}
