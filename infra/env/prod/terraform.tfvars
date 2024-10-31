tags = {
    project = "Gregorian"
    environment = "prod"
}
environment = "prod"
aws-region = "us-east-2"

#NETWORK
vpc-cidr-block = "172.28.0.0/16"
subnet-a-cidr-block = "172.28.0.0/24"
subnet-b-cidr-block = "172.28.1.0/24"
subnet-c-cidr-block = "172.28.2.0/24"
subnet-a-availability-zone = "us-east-2a"
subnet-b-availability-zone = "us-east-2b"
subnet-c-availability-zone = "us-east-2c"
ssh-src-cidr = ["177.92.204.11"]

#EC2
aws-key-name = "GregorianKeyPair"
aws-public-key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7o1iMfa+r33aHusBSzbaEzfNlWNEJVuMsVqPKN2eWkNeK1eMNeNNThf9DIWBGLxGEF/+QB6qQeak4r4/45ElK6yLp/qRlEIZIcCBQIfSbp9his/90E+iG+Z7BpUf8vFfj9tXBxqaim91dqAhUsnqNL+mT/VZXiFnHp17KvnxsEoUiqwQYni3pms8/G/Zg6Cw6/8LqeyRXzvPcfcalZ6UPOb1dzRXFKOLjdAPTIUsHkKExeu6qd4pKvu0+vv+qHOmQTuuRLXvtoxh5PJqJ50KCjA2b8AIX9qo3K2U7T0AWvq0wdcGoPcc2lfT/pynuYoxhqMmTuwIaF0bXPPZ5hXGarCA8iZfwLgCvPLeBBEjW33FSHr/+Pw25P0dCboEd+46qJyhw5FQvwHmcNnjQMlkCGJLX5GYAlR/OK8JSH70cL4KSbJhsm2zRoLZdgGnUnXQ+olf4FgaD5Et+qY2umj7EpIdLgpNuMldFI3eUyeA/1I3jhurOPivmWLALCZeJiUc= root@GUILHERME-PC"


#RDS
rds-allocated-storage = 10
rds-max-allocated-storage = 15
rds-engine = "mysql"
rds-engine-version = "8.0"
rds-instance-class = "db.t3.micro"
rds-db-name = "gregorian"
rds-db-username = "root"
rds-db-password = "Gmn!0213"
rds-skip-final-snapshot = true
rds-multi-az = true
rds-publicly-acessible = false

#AUTOSCALING E LOADBALANCER
as-name = "GregorianAutosacling"
max-size = 5
min-size = 1
desired-capacity = 2
asg-health-check-type = "ELB"
image-id = "ami-0ea3c35c5c3284d82"
as-instance-type = "t2.small"