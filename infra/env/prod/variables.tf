#Definição das variáveis e seus tipos
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
variable "aws-key-name" {
  type = string
}
variable "aws-public-key" {
  type = string
}

#RDS
variable "rds-allocated-storage" {
  type = number
}
variable "rds-max-allocated-storage" {
  type = number
}
variable "rds-engine" {
  type = string
}
variable "rds-engine-version" {
  type = string
}
variable "rds-instance-class" {
  type = string
}
variable "rds-db-name" {
  type = string
}
variable "rds-db-username" {
  type = string
}
variable "rds-db-password" {
  type = string
}
variable "rds-skip-final-snapshot" {
  type = bool
}
variable "rds-multi-az" {
  type = bool
}
variable "rds-publicly-acessible" {
  type = bool
}

#AUTO SCALING
variable "max-size" {
  type = number
}
variable "min-size" {
  type = number
}
variable "desired-capacity" {
  type = number
}
variable "asg-health-check-type" {
  type = string
}
variable "image-id" {
  type = string
}
variable "as-instance-type" {
  type = string
}

#S3
variable "bucket" {
  type = string
}

variable "aws-acount-id" {
  type = string
}

variable "jwt-secret" {
  type = string
}