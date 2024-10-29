variable "tags" {}
variable "aws-region" {}
variable "environment" {
  type = string
}

#NETWORK (VPC)
variable "vpc-cidr-block" {}
variable "enable_dns_hostnames" {}
variable "enable_dns_support" {}
variable "subnet1-cidr-block" {}
variable "subnet1-availability-zone" {}
variable "subnet2-cidr-block" {}
variable "subnet2-availability-zone" {}
variable "subnet3-cidr-block" {}
variable "subnet3-availability-zone" {}
variable "map-public-ip-on-launch" {}
variable "sg-api-http-from-port" {}
variable "sg-api-http-to-port" {}
variable "sg-api-ssh-cidr" {}
variable "sg-api-ssh-from-port" {}
variable "sg-api-ssh-to-port" {}
variable "sg-rds-ssh-cidr" {}
variable "sg-rds-ssh-from-port" {}
variable "sg-rds-ssh-to-port" {}
variable "sg-rds-mysql-cidr" {}
variable "sg-rds-mysql-from-port" {}
variable "sg-rds-mysql-to-port" {}

#EC2
variable "aws-key-name" {}
variable "aws-public-key" {}

#RDS
variable "allocated-storage" {}
variable "max-allocated-storage" {}
variable "engine" {}
variable "engine-version" {}
variable "instance-class" {}
variable "db-name" {}
variable "db-username" {}
variable "db-password" {}
variable "skip-final-snapshot" {}
variable "multi-az" {}
variable "publicly-acessible" {}
variable "db-subnet-group-name" {}
variable "iam-role-arn-for-option-group" {}

#AUTO SCALING
variable "as-name" {}
variable "internal" {}
variable "load-balancer-type" {}
variable "enable-deletion-protection" {}
variable "lb-target-port" {}
variable "lb-protocol" {}
variable "lb-target-type" {}
variable "lb-listener-port" {}
variable "lb-listener-protocol" {}
variable "max-size" {}
variable "min-size" {}
variable "desired-capacity" {}
variable "asg-health-check-type" {}
variable "image-id" {}
variable "as-instance-type" {}
