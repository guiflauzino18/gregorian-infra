variable "aws-region" {
  type = string
}

variable "tags" {
  type = map(string)
}

#LOAD BALANCERS
variable "name" {
  type = string
}

variable "internal" {
  type = bool
}

variable "load-balancer-type" {
  type = string
}

variable "lb-security-groups" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}

variable "enable-deletion-protection" {
  type = bool
}

variable "lb-target-port" {
  type = number
}

variable "lb-protocol" {
  type = string
}

variable "lb-target-type" {
  description = "value = Target type: ip for ALB/NLB or instance for Autoscaling"
  type = string
  default = "instance"
}

variable "vpc-id" {
  type = string
}

variable "lb-listener-port" {
  type = number
}

variable "lb-listener-protocol" {
  type = string
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


#LAUNCH TEMPLATE
variable "image-id" {
  type = string
}

variable "as-instance-type" {
  type = string
}

variable "key-name" {
  type = string
}

variable "user-data" {
  type = string
}

variable "as-vpc-sg-ids" {
  type = set(string)
}
