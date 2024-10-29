variable "tags" {
  type = map(string)
}

variable "aw-region" {
    type = string
}

variable "vpc-cidr-block" {
  type = string
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "enable_dns_support" {
  type = bool
}

variable "subnet1-cidr-block" {
  type = string
}

variable "subnet2-cidr-block" {
  type = string
}

variable "subnet3-cidr-block" {
  type = string
}

variable "subnet1-availability-zone" {
  type = string
}

variable "subnet2-availability-zone" {
  type = string
}

variable "subnet3-availability-zone" {
  type = string
}

variable "map-public-ip-on-launch" {
  type = bool
}

variable "sg-api-http-from-port" {
  type = string
}

variable "sg-api-http-to-port" {
  type = string
}

variable "sg-api-ssh-cidr" {
  type = string
}

variable "sg-api-ssh-from-port" {
  type = string
}

variable "sg-api-ssh-to-port" {
  type = string
}

variable "sg-rds-ssh-cidr" {
  type = string
}

variable "sg-rds-ssh-from-port" {
  type = string
}

variable "sg-rds-ssh-to-port" {
  type = string
}

variable "sg-rds-mysql-cidr" {
  type = string
}

variable "sg-rds-mysql-from-port" {
  type = string
}

variable "sg-rds-mysql-to-port" {
  type = string
}