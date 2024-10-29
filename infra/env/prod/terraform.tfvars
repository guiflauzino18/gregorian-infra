tags = {
    Name = "GregorianInfra"
}
environment = "prod"
aws-region = "us-east-2"
#NETWORK
vpc-cidr-block = "172.28.0.0/16"
enable_dns_hostnames = true
enable_dns_support = true
subnet1-cidr-block = "172.28.0.0/24"
subnet2-cidr-block = "172.28.1.0/24"
subnet3-cidr-block = "172.28.2.0/24"
subnet1-availability-zone = "us-east-2a"
subnet2-availability-zone = "us-east-2b"
subnet3-availability-zone = "us-east-2c"
map-public-ip-on-launch = true
sg-api-http-from-port = "443"
sg-api-http-to-port = "443"
sg-api-ssh-cidr = "172.28.0.0/24"
sg-api-ssh-from-port = "22"
sg-api-ssh-to-port = "22"
sg-rds-mysql-cidr = "172.28.0.0/24"
sg-rds-mysql-from-port = "3306"
sg-rds-mysql-to-port = "3306"
sg-rds-ssh-cidr = "172.28.0.0/24"
sg-rds-ssh-from-port = "22"
sg-rds-ssh-to-port = "22"

#EC2
aws-key-name = "GregorianKeyPair"
aws-public-key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7o1iMfa+r33aHusBSzbaEzfNlWNEJVuMsVqPKN2eWkNeK1eMNeNNThf9DIWBGLxGEF/+QB6qQeak4r4/45ElK6yLp/qRlEIZIcCBQIfSbp9his/90E+iG+Z7BpUf8vFfj9tXBxqaim91dqAhUsnqNL+mT/VZXiFnHp17KvnxsEoUiqwQYni3pms8/G/Zg6Cw6/8LqeyRXzvPcfcalZ6UPOb1dzRXFKOLjdAPTIUsHkKExeu6qd4pKvu0+vv+qHOmQTuuRLXvtoxh5PJqJ50KCjA2b8AIX9qo3K2U7T0AWvq0wdcGoPcc2lfT/pynuYoxhqMmTuwIaF0bXPPZ5hXGarCA8iZfwLgCvPLeBBEjW33FSHr/+Pw25P0dCboEd+46qJyhw5FQvwHmcNnjQMlkCGJLX5GYAlR/OK8JSH70cL4KSbJhsm2zRoLZdgGnUnXQ+olf4FgaD5Et+qY2umj7EpIdLgpNuMldFI3eUyeA/1I3jhurOPivmWLALCZeJiUc= root@GUILHERME-PC"

#RDS
allocated-storage = 10
max-allocated-storage = 15
engine = "mysql"
engine-version = "8.0"
instance-class = "db.t3.micro"
db-name = "gregorian"
db-username = "root"
db-password = "Gmn!0213"
skip-final-snapshot = true
multi-az = true
publicly-acessible = false 
db-subnet-group-name = "subnet-default"
iam-role-arn-for-option-group = ""

#AUTOSCALING E LOADBALANCER
as-name = "GregorianAutosacling"
internal = false
load-balancer-type = "application"
enable-deletion-protection = false
lb-target-port = 80
lb-protocol = "HTTP"
lb-target-type = "instance"
lb-listener-port = 443
lb-listener-protocol = "HTTP"
max-size = 5
min-size = 1
desired-capacity = 2
asg-health-check-type = "ELB"
image-id = "ami-0ea3c35c5c3284d82"
as-instance-type = "t2.small"