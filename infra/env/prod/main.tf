###################################VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc-cidr-block
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = var.tags
}

#############################SUBNETS
#SUBNET A
resource "aws_subnet" "subnet_a" {
  vpc_id = aws_vpc.this.id
  cidr_block = var.subnet-a-cidr-block
  map_public_ip_on_launch = true
  availability_zone = var.subnet-a-availability-zone
  tags = var.tags
}

#SUBNET B
resource "aws_subnet" "subnet_b" {
  vpc_id = aws_vpc.this.id
  cidr_block = var.subnet-b-cidr-block
  map_public_ip_on_launch = true
  availability_zone = var.subnet-b-availability-zone
  tags = var.tags
}

#SUBNET C
resource "aws_subnet" "subnet_c" {
  vpc_id = aws_vpc.this.id
  cidr_block = var.subnet-c-cidr-block
  map_public_ip_on_launch = true
  availability_zone = var.subnet-c-availability-zone
  tags = var.tags
}

#########################INTERNET GATEWAY
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = var.tags
}

#########################ROUTE TABLE
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  tags = var.tags

  #ROTA DE REDE LOCAL INTERNET
  route {
    cidr_block = var.vpc-cidr-block
    gateway_id = "local"
  }

  #ROTA DEFAULT 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}


#ASSOCIAR SUBNETS À ROUTE TABLE 
resource "aws_route_table_association" "rta-subnet-a" {
  subnet_id = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.this.id
}
resource "aws_route_table_association" "rta-subnet-b" {
  subnet_id = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.this.id
}
resource "aws_route_table_association" "rta-subnet-c" {
  subnet_id = aws_subnet.subnet_c.id
  route_table_id = aws_route_table.this.id
}


#########################SECURITY GROUPS

# SG FOR INSTANCES
resource "aws_security_group" "SGForInstances" {
  name = "SGForInstances"
  description = "Security Group para Instancias"
  vpc_id = aws_vpc.this.id
  tags = var.tags
}

# SG FOR LOADBALANCER
resource "aws_security_group" "SGForLoadBalancer" {
  name = "SGForLoadBalancer"
  description = "Security Group para o Load Balancer"
  vpc_id = aws_vpc.this.id
  tags = var.tags
}
# SG FOR RDS
resource "aws_security_group" "SGForRDS" {
  name = "SGForRDS"
  description = "Security Group para o RDS"
  vpc_id = aws_vpc.this.id
  tags = var.tags
}

##################### INSTANCES POLICY
#PERMITE TRÁFEGO DE TODA REDE VPC
resource "aws_vpc_security_group_ingress_rule" "allowAllFromVPCCidr" {
  security_group_id = aws_security_group.SGForInstances.id
  cidr_ipv4 = var.vpc-cidr-block
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "AllowSSH" {
  count = length(var.ssh-src-cidr)
  security_group_id = aws_security_group.SGForInstances.id
  cidr_ipv4 = var.ssh-src-cidr[count.index]
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
}

#PERMITE TODO TRÁFEGO DE SAÍDA
resource "aws_vpc_security_group_egress_rule" "AllowAllEgress" {
  security_group_id = aws_security_group.SGForInstances.id
  cidr_ipv4 = var.vpc-cidr-block
  ip_protocol = "-1" #Todas as portas
}

###################LOAD BALANCER POLICY
resource "aws_vpc_security_group_ingress_rule" "allowHttpIn" {
  security_group_id = aws_security_group.SGForLoadBalancer.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  ip_protocol = "tcp"
}

#################### RDS POLICY
resource "aws_vpc_security_group_ingress_rule" "allowMysql" {
  security_group_id = aws_security_group.SGForRDS.id
  cidr_ipv4 = var.vpc-cidr-block
  from_port = "3306"
  ip_protocol = "tcp"
  to_port = "3306"
}



######################EC2
resource "aws_key_pair" "this" {
  key_name = var.aws-key-name
  public_key = var.aws-public-key
}


##################RDS
resource "aws_db_instance" "this" {
  allocated_storage = var.rds-allocated-storage
  max_allocated_storage = var.rds-max-allocated-storage
  engine = var.rds-engine
  engine_version = var.rds-engine-version
  instance_class = var.rds-instance-class
  db_name = var.rds-db-name
  username = var.rds-db-username
  password = var.rds-db-password
  skip_final_snapshot = var.rds-skip-final-snapshot
  multi_az = var.rds-multi-az
  publicly_accessible = var.rds-publicly-acessible
  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.SGForInstances.id,aws_security_group.SGForRDS.id]
  tags = var.tags
}

resource "aws_db_subnet_group" "this" {
  name = "GregorianSubnets"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id, aws_subnet.subnet_c.id]
}

###################LOAD BALANCER
resource "aws_lb" "this" {
  name = "Gregorian Load Balancer"
  internal = false 
  load_balancer_type = "application"
  security_groups = [aws_security_group.SGForLoadBalancer.id]
  subnets = [ aws_subnet.subnet_a.id,aws_subnet.subnet_b.id, aws_subnet.subnet_c ]
  enable_deletion_protection = false
  tags = var.tags
}

#TARGET GROUP - Target Group é o grupo de destino para onde as requisições serão feitas.
#Esse Target Group será usado também no autoscalink
resource "aws_lb_target_group" "this" {
  name = "tg-gregorian"
  port = 80
  protocol = "http"
  target_type = "instance" #Instance quando usado junto cm autoscaling
  vpc_id = aws_vpc.this.id
  tags = merge({"name" = "tg-gregorian",}, var.tags)
}

#LISTENER - O que o Load Balancer ficará escutando para encaminhar para o grupo target
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port = "443"
  protocol = "tcp"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
  depends_on = [ aws_lb_target_group.this ]
}


###########AUTO SCALING
#LAUNCH TEMPLATE
resource "aws_launch_template" "this" {
  name = "GregorianImage"
  image_id = var.image-id
  instance_type = var.as-instance-type
  key_name = var.aws-key-name
  user_data = var.as-user-data
  tags = merge({"Resource" = "gregorian-template"}, var.tags)
  network_interfaces {
    security_groups = [aws_security_group.SGForInstances.id]
    associate_public_ip_address = true
  }
}

#AUTOSCALING GROUP
resource "aws_autoscaling_group" "this" {
  name = "GregorianAutoScalingGroup"
  max_size = var.max-size
  min_size = var.min-size
  desired_capacity = var.desired-capacity
  health_check_grace_period = 300
  health_check_type = var.asg-health-check-type
  vpc_zone_identifier = [ aws_subnet.subnet_a.id, aws_subnet.subnet_b.id, aws_subnet.subnet_c.id ]
  target_group_arns = [ aws_lb_target_group.this.arn ]
  launch_template {
    id = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version
  }
}

#ATTACH INSTANCES TO TARGET GROUP
#pegar todas as instancias criadas pelo auto scaling
data "aws_instances" "this" {
  filter {
    name = "tag:Resource"
    values = ["gregorian-template"]
  }
}

#Anexar as Instancias encontradas acima no Target Group
resource "aws_lb_target_group_attachment" "this" {
  count = length(data.aws_instances.this.ids) #Count quantas vezes esse bloco será executado. No caso esta pegando o tamanho da lista de instancias encontradas.
  target_group_arn = aws_lb_target_group.this.arn
  target_id = data.aws_instances.this.ids[count.index]
}

#POLITICAS DE ESCALONAMENTO
resource "aws_autoscaling_policy" "up" {
  name = "gregorian-autoscaling-up"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "1" # Incrementa em uma máquina
  cooldown = "300"
  policy_type = "SimpleScaling"
}

resource "aws_autoscaling_policy" "down" {
  name = "gregorian-autoscaling-down"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "-1" # Incrementa em uma máquina
  cooldown = "300"
  policy_type = "SimpleScaling"
}

