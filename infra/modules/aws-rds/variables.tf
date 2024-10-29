variable "aws-region" {type = string }
variable "allocated-storage" { type = number}
variable "max-allocated-storage" { type = number}
variable "engine" {type = string}
variable "engine-version" {type = string}
variable "instance-class" {type = string}
variable "db-name" {type = string}
variable "db-username" {type = string}
variable "db-password" {type = string}
variable "skip-final-snapshot" {type = bool}
variable "multi-az" {type = bool}
variable "publicly-acessible" {type = bool}
variable "db-subnet-group-name" {type = string}
variable "vpc-security-group-ids" {type = list(string)}
variable "db-group-subnet-ids" {type = list(string)}
variable "iam-role-arn-for-option-group" {type = string}
variable "tags" {type = map(string)}


