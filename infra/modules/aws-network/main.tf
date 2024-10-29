resource "aws_vpc" "this" {
  cidr_block = var.vpc-cidr-block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  tags = var.tags
}

resource "aws_subnet" "sub1" {
  vpc_id = aws_vpc.this.id
  cidr_block = var.subnet1-cidr-block
  map_public_ip_on_launch = var.map-public-ip-on-launch
  availability_zone = var.subnet1-availability-zone
  tags = var.tags
}

resource "aws_subnet" "sub2" {
  vpc_id = aws_vpc.this.id
  cidr_block = var.subnet2-cidr-block
  map_public_ip_on_launch = var.map-public-ip-on-launch
  availability_zone = var.subnet2-availability-zone
  tags = var.tags
}

resource "aws_subnet" "sub3" {
  vpc_id = aws_vpc.this.id
  cidr_block = var.subnet3-cidr-block
  map_public_ip_on_launch = var.map-public-ip-on-launch
  availability_zone = var.subnet3-availability-zone
  tags = var.tags
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = var.tags
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  tags = var.tags

  route {
    cidr_block = var.vpc-cidr-block
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  
}

resource "aws_route_table_association" "sub1" {
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.this.id
}
resource "aws_route_table_association" "sub2" {
    subnet_id = aws_subnet.sub2.id
    route_table_id = aws_route_table.this.id
}
resource "aws_route_table_association" "sub3" {
    subnet_id = aws_subnet.sub3.id
    route_table_id = aws_route_table.this.id
}

resource "aws_security_group" "SG_API" {
    name = "SecurityGroupGregorianAPI"
    description = "Security Group for Gregorian API"
    vpc_id = aws_vpc.this.id
    tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "APIAllowHttp" {
  security_group_id = aws_security_group.SG_API.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = var.sg-api-http-from-port
  ip_protocol = "tcp"
  to_port = var.sg-api-http-to-port
}

resource "aws_vpc_security_group_ingress_rule" "APIAllowSsh" {
  security_group_id = aws_security_group.SG_API.id
  cidr_ipv4 = var.sg-api-ssh-cidr
  from_port = var.sg-api-ssh-from-port
  ip_protocol = "tcp"
  to_port = var.sg-api-ssh-to-port
}

resource "aws_vpc_security_group_egress_rule" "APIAllowAllEgress" {
    security_group_id = aws_security_group.SG_API.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_security_group" "SG_RDS" {
    name = "SecurityGroupGregorianRDS"
    description = "Security Group for Gregorian RDS MySQL"
    vpc_id = aws_vpc.this.id
    tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "RDSallowSsh" {
  security_group_id = aws_security_group.SG_RDS.id
  cidr_ipv4 = var.sg-rds-ssh-cidr
  from_port = var.sg-rds-ssh-from-port
  ip_protocol = "tcp"
  to_port = var.sg-rds-ssh-to-port
}

resource "aws_vpc_security_group_ingress_rule" "RDSallowMySQL" {
  security_group_id = aws_security_group.SG_RDS.id
  cidr_ipv4 = var.sg-rds-mysql-cidr
  from_port = var.sg-rds-mysql-from-port
  ip_protocol = "tcp"
  to_port = var.sg-rds-mysql-to-port
}

resource "aws_vpc_security_group_egress_rule" "RDSAllowAllEgress" {
    security_group_id = aws_security_group.SG_RDS.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}