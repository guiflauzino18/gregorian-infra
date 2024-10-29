#VPC, SUBNETS, SECURITY GROUPS
module "network" {
  source = "../../modules/aws-network"
    #VPC
    aw-region = var.aws-region
    tags = var.tags
    vpc-cidr-block = var.vpc-cidr-block
    enable_dns_hostnames = var.enable_dns_hostnames
    enable_dns_support = var.enable_dns_support

    #SUBNET 1
    subnet1-cidr-block = var.subnet1-cidr-block
    map-public-ip-on-launch = var.map-public-ip-on-launch
    subnet1-availability-zone = var.subnet1-availability-zone

    #SUBNET 2
    subnet2-cidr-block = var.subnet2-cidr-block
    subnet2-availability-zone = var.subnet2-availability-zone

    #SUBNET 3
    subnet3-cidr-block = var.subnet3-cidr-block
    subnet3-availability-zone = var.subnet3-availability-zone

    #SECURITY GROUP API
    sg-api-http-from-port = var.sg-api-http-from-port
    sg-api-http-to-port = var.sg-api-http-to-port
    sg-api-ssh-cidr = var.sg-api-ssh-cidr
    sg-api-ssh-from-port = var.sg-api-ssh-from-port
    sg-api-ssh-to-port = var.sg-api-ssh-to-port

    #SECURITY GROUP RDS
    sg-rds-mysql-cidr = var.sg-rds-mysql-cidr
    sg-rds-mysql-from-port = var.sg-rds-mysql-from-port
    sg-rds-mysql-to-port = var.sg-rds-mysql-to-port
    sg-rds-ssh-cidr = var.sg-rds-ssh-cidr
    sg-rds-ssh-from-port = var.sg-rds-ssh-from-port
    sg-rds-ssh-to-port = var.sg-rds-ssh-to-port
}

#RDS
module "rds" {
  source = "../../modules/aws-rds"
  aws-region = var.aws-region
  allocated-storage = var.allocated-storage
  max-allocated-storage = var.max-allocated-storage
  engine = var.engine
  engine-version = var.engine-version
  instance-class = var.instance-class
  db-name = var.db-name
  db-username = var.db-username
  db-password = var.db-password
  skip-final-snapshot = var.skip-final-snapshot
  multi-az = var.multi-az
  publicly-acessible = var.publicly-acessible
  db-subnet-group-name = var.db-subnet-group-name
  vpc-security-group-ids = ["${module.network.SGForRDS}"]
  db-group-subnet-ids = ["${module.network.subnet1-id}","${module.network.subnet2-id}","${module.network.subnet3-id}"]
  iam-role-arn-for-option-group = var.iam-role-arn-for-option-group
  tags = var.tags
  
}

#EC2 KEYPAIR
module "ec2" {
  source = "../../modules/aws-ec2"
  aws-key-name = var.aws-key-name
  aws-public-key = var.aws-public-key
}

#AUTOSCALING E LOAD BALANCER
module "elb" {
  source = "../../modules/aws-elb"
  name = var.as-name
  aws-region = var.aws-region
  internal = var.internal
  load-balancer-type = var.load-balancer-type
  lb-security-groups = [ "${module.network.SGForAPIInstances}" ] 
  subnets = [ "${module.network.subnet1-id}","${module.network.subnet2-id}","${module.network.subnet3-id}" ]
  enable-deletion-protection = var.enable-deletion-protection
  tags = var.tags
  lb-target-port = var.lb-target-port
  lb-protocol = var.lb-protocol
  lb-target-type = var.lb-target-type
  vpc-id = module.network.vpc-id
  lb-listener-port = var.lb-listener-port
  lb-listener-protocol = var.lb-listener-protocol
  image-id = var.image-id
  as-instance-type = var.as-instance-type
  key-name = module.ec2.key_name
  user-data = filebase64("${path.module}/userData.sh")
  as-vpc-sg-ids = [ module.network.SGForAPIInstances ]
  max-size = var.max-size
  min-size = var.min-size
  desired-capacity = var.desired-capacity
  asg-health-check-type = var.asg-health-check-type
  
}