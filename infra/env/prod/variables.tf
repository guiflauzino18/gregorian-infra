variable "tags" {
  type = map(string)
}

variable "aws-region" {
  type = string
}

variable "environment" {
  type = string
}

#NETWORK (VPC)
variable "vpc-cidr-block" {
  type = string
}

variable "subnet-a-cidr-block" {
  type = string
}
variable "subnet-a-availability-zone" {
  type = string
}
variable "subnet-b-cidr-block" {
  type = string
}
variable "subnet-b-availability-zone" {
  type = string
}
variable "subnet-c-cidr-block" {
  type = string
}
variable "subnet-c-availability-zone" {
  type = string
}

variable "ssh-src-cidr" {
  type = list(string)
}


#EC2
variable "aws-key-name" {}
variable "aws-public-key" {}

#RDS
variable "rds-allocated-storage" {}
variable "rds-max-allocated-storage" {}
variable "rds-engine" {}
variable "rds-engine-version" {}
variable "rds-instance-class" {}
variable "rds-db-name" {}
variable "rds-db-username" {}
variable "rds-db-password" {}
variable "rds-skip-final-snapshot" {}
variable "rds-multi-az" {}
variable "rds-publicly-acessible" {}

#AUTO SCALING
variable "as-name" {}
variable "max-size" {}
variable "min-size" {}
variable "desired-capacity" {}
variable "asg-health-check-type" {}
variable "image-id" {}
variable "as-instance-type" {}
variable "as-user-data" {}