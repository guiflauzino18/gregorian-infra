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

  #ROTA DE REDE LOCAL
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
  name = "for-instances"
  description = "Security Group para Instancias"
  vpc_id = aws_vpc.this.id
  tags = var.tags
}

# SG FOR LOADBALANCER
resource "aws_security_group" "SGForLoadBalancer" {
  name = "for-loadbalancer"
  description = "Security Group para o Load Balancer"
  vpc_id = aws_vpc.this.id
  tags = var.tags
}
# SG FOR RDS
resource "aws_security_group" "SGForRDS" {
  name = "for-rds"
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

#Permite entrada de tráfego na porta 8080 vindo dos hosts do Security Group do Load Balancer
resource "aws_vpc_security_group_ingress_rule" "allow8080FromELB" {
  security_group_id = aws_security_group.SGForInstances.id
  ip_protocol = "tcp"
  from_port = 8080
  to_port = 8080
  referenced_security_group_id = aws_security_group.SGForLoadBalancer.id
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
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1" #Todas as portas
}

###################LOAD BALANCER POLICY
resource "aws_vpc_security_group_ingress_rule" "allowHttpsIn" {
  security_group_id = aws_security_group.SGForLoadBalancer.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  ip_protocol = "tcp"
  to_port = "443"
}

resource "aws_vpc_security_group_ingress_rule" "allowTomcatIn" {
  security_group_id = aws_security_group.SGForLoadBalancer.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 8080
  ip_protocol = "tcp"
  to_port = "8080"
}

resource "aws_vpc_security_group_ingress_rule" "allowHttpIn" {
  security_group_id = aws_security_group.SGForLoadBalancer.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  ip_protocol = "tcp"
  to_port = "80"
}

#PERMITE TODO TRÁFEGO DE SAÍDA
resource "aws_vpc_security_group_egress_rule" "AllowAllEgressLB" {
  security_group_id = aws_security_group.SGForLoadBalancer.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1" #Todas as portas
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
  parameter_group_name = aws_db_parameter_group.this.name
  #apply_immediately = true
}

resource "aws_db_subnet_group" "this" {
  name = "gregorian-subnets"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id, aws_subnet.subnet_c.id]
}

#Parameter Group para configurar skip_name_resolve para true. Evita erro de Cannot resolve dns name no RDS
resource "aws_db_parameter_group" "this" {
  family = "mysql8.0"
  description = "Parameter Group For RDS Instance"
  name = "rds-parameter-group"
  
  parameter {
    name = "skip_name_resolve"
    value = "1"
    apply_method = "pending-reboot"
  }
}

###################LOAD BALANCER
resource "aws_lb" "this" {
  name = "gregorian-load-balancer"
  internal = false 
  load_balancer_type = "application"
  security_groups = [aws_security_group.SGForLoadBalancer.id]
  subnets = [ aws_subnet.subnet_a.id,aws_subnet.subnet_b.id, aws_subnet.subnet_c.id ]
  enable_deletion_protection = false
  
  tags = var.tags
}

#TARGET GROUP - Target Group é o grupo de destino para onde as requisições serão feitas.
#Esse Target Group será usado também no autoscaling
resource "aws_lb_target_group" "this" {
  name = "tg-gregorian"
  target_type = "instance" #Instance quando usado junto cm autoscaling
  protocol = "HTTP"
  vpc_id = aws_vpc.this.id
  tags = merge({"name" = "tg-gregorian",}, var.tags)
  health_check {
    path = "/api/check"
    interval = 30
    timeout = 5
    healthy_threshold = 3
    unhealthy_threshold = 2
    matcher = 200
  }
}


#LISTENER - O que o Load Balancer ficará escutando para encaminhar para o grupo target
resource "aws_lb_listener" "Https" {
  load_balancer_arn = aws_lb.this.arn
  port = "443"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
  depends_on = [ aws_lb_target_group.this ]
}

resource "aws_lb_listener" "Http" {
  load_balancer_arn = aws_lb.this.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
  depends_on = [ aws_lb_target_group.this ]
}

resource "aws_lb_listener" "TomCat8080" {
  load_balancer_arn = aws_lb.this.arn
  port = "8080"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
  depends_on = [ aws_lb_target_group.this ]
}


###########AUTO SCALING
#CRIA  ARQUIVO DOCKER COMPOSE
resource "local_file" "docker-coompose" {
  filename = "${path.module}/docker-compose.yml"
  content  = <<-EOF
services:
 gregorian-api:
  image: ${var.aws-acount-id}.dkr.ecr.${var.aws-region}.amazonaws.com/gregorian-api:latest
  container_name: gregorian-api
  restart: always
  environment:
   - MYSQL_IP=${aws_db_instance.this.address}
   - MYSQL_USERNAME=${var.rds-db-username}
   - MYSQL_PASSWORD=${var.rds-db-password}
   - JWT_SECRET=${var.jwt-secret}
  ports:
   - 8080:8080
  network_mode: "host"
  volumes:
   - vol-gregorian:/gregorian

volumes:
 vol-gregorian:
EOF
  depends_on = [ aws_db_instance.this ]
}

#ENVIA ARQUIVO DOCKER-COMPOSE.YML PARA O BUCKET S3
resource "aws_s3_object" "docker-compose" {
  bucket = var.bucket
  key    = "docker-compose.yml" 
  source = "./docker-compose.yml" 
  acl    = "private"
  depends_on = [ local_file.docker-coompose ]
}

#CRIA ARQUIVO USERDATA.SH
resource "local_file" "userData" {
  filename = "${path.module}/userData.sh"
  content = <<-EOF
#!/bin/bash

#Instala Docker
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

#Instala Mysql Client
sudo apt install -y mysql-client-core-8.0

#instala aws cli
cd /tmp
apt install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Loga docker no ECR
aws ecr get-login-password --region ${var.aws-region} | docker login --username AWS --password-stdin ${var.aws-acount-id}.dkr.ecr.${var.aws-region}.amazonaws.com

#Configura Docker Compose
mkdir /gregorian
cd /gregorian
aws s3 cp s3://s3.gregorian/docker-compose.yml .
docker compose pull
docker compose up -d
EOF
}

#ENVIA ARQUIVO USERDATA.SH PARA O BUCKET S3
resource "aws_s3_object" "usedataToS3" {
  bucket = var.bucket
  key    = "userData.sh" 
  source = "./userData.sh" 
  acl    = "private"
  depends_on = [ local_file.userData ]
  
}


#POLÍTICAS EC2 PARA ACESSO AO BUCKET S3
#ROLE PERMITNDO EC2 ASSUMIR ESTA ROLE
resource "aws_iam_role" "role-ec2-access-s3" {
  name = "ec2-access-s3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

#POLÍTICA PARA ACESSAR O BUCKET S3
resource "aws_iam_policy" "ec2-access-s3-policy" {
  name        = "ec2-access-s3-policy"
  description = "Permissão para acessar o bucket S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject"]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::s3.gregorian/*"
      }
    ]
  })
}

#POLÍTICA PARA ACESSAR O ECR
resource "aws_iam_policy" "ec2-access-ecr-policy" {
  name        = "ec2-access-ecr-policy"
  description = "Permissão para acessar o ecr"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid": "Ecr",
        "Effect": "Allow",
        "Action": "ecr:*",
        "Resource": "*"
      }
    ]
  })
}

#ANEXA A POLÍTICA ACIMA À ROLE
resource "aws_iam_role_policy_attachment" "ecr_access_attachment" {
  role       = aws_iam_role.role-ec2-access-s3.name
  policy_arn = aws_iam_policy.ec2-access-ecr-policy.arn
}

resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.role-ec2-access-s3.name
  policy_arn = aws_iam_policy.ec2-access-s3-policy.arn
}

#CRIA UM INSTANCE PROFILE QUE SERÁ ANEXADO À LAUCH TEMPLATE
resource "aws_iam_instance_profile" "this" {
  name = "ec2_instance_profile"
  role = aws_iam_role.role-ec2-access-s3.name
}

#LAUNCH TEMPLATE
resource "aws_launch_template" "this" {
  name = "gregorian-image"
  image_id = var.image-id
  instance_type = var.as-instance-type
  key_name = var.aws-key-name
  update_default_version = true
  tags = merge({"Resource" = "gregorian-template"}, var.tags)
  user_data = "${base64encode(local_file.userData.content)}"
  network_interfaces {
    security_groups = [aws_security_group.SGForInstances.id]
    associate_public_ip_address = true
  }
  iam_instance_profile {
    arn = aws_iam_instance_profile.this.arn
  }
  depends_on = [ local_file.userData ]
}


#AUTOSCALING GROUP
resource "aws_autoscaling_group" "this" {
  name = "gregorian-autoScaling-group"
  max_size = var.max-size
  min_size = var.min-size
  desired_capacity = var.desired-capacity #Capacidade desejada = ao menos 2
  health_check_grace_period = 300
  health_check_type = var.asg-health-check-type
  vpc_zone_identifier = [ aws_subnet.subnet_a.id, aws_subnet.subnet_b.id, aws_subnet.subnet_c.id ]
  target_group_arns = [ aws_lb_target_group.this.arn ]
  launch_template {
    id = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version   
  }
  depends_on = [ aws_s3_object.docker-compose ]
  
}

#ATTACH INSTANCES TO TARGET GROUP
#pegar todas as instancias criadas pelo auto scaling
data "aws_instances" "this" {
  filter {
    name = "tag:aws:autoscaling:groupName"
    values = ["gregorian-autoScaling-group"]
  }
}

#Anexar as Instancias encontradas acima no Target Group
resource "aws_lb_target_group_attachment" "instanceIn8080" {
  count = length(data.aws_instances.this.ids) #Count quantas vezes esse bloco será executado. No caso esta pegando o tamanho da lista de instancias encontradas.
  target_group_arn = aws_lb_target_group.this.arn
  target_id = data.aws_instances.this.ids[count.index]
  port = 8080
}

resource "aws_lb_target_group_attachment" "instanceIn80" {
  count = length(data.aws_instances.this.ids) #Count quantas vezes esse bloco será executado. No caso esta pegando o tamanho da lista de instancias encontradas.
  target_group_arn = aws_lb_target_group.this.arn
  target_id = data.aws_instances.this.ids[count.index]
  port = 80
}

#POLITICAS DE ESCALONAMENTO
resource "aws_autoscaling_policy" "up" {
  name = "gregorian-autoscaling-up"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "1" # Incrementa em uma máquina
  cooldown = "300" #aguarda 300 segundos antes de aplicar novamente uma política
  policy_type = "SimpleScaling"
}

resource "aws_autoscaling_policy" "down" {
  name = "gregorian-autoscaling-down"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "-1" # Decrementa em uma máquina
  cooldown = "300" #aguarda 300 segundos antes de aplicar novamente uma política
  policy_type = "SimpleScaling"
}
