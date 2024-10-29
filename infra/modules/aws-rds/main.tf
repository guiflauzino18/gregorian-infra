resource "aws_db_instance" "this" {
  allocated_storage = var.allocated-storage
  max_allocated_storage = var.max-allocated-storage
  engine = var.engine
  engine_version = var.engine-version
  instance_class = var.instance-class
  db_name = var.db-name
  username = var.db-username
  password = var.db-password
  skip_final_snapshot = var.skip-final-snapshot
  multi_az = var.multi-az
  publicly_accessible = var.publicly-acessible
  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc-security-group-ids
  option_group_name = aws_db_option_group.this.name
  tags = merge({"name" = "${var.db-name}-dbname", }, var.tags)
}

resource "aws_db_subnet_group" "this" {
  name = var.db-subnet-group-name
  subnet_ids = var.db-group-subnet-ids
}

resource "aws_db_option_group" "this" {
  name = "${var.db-name}-option-group"
  option_group_description = "option Group for ${var.db-name}"
  engine_name = var.engine
  major_engine_version = var.engine-version
  tags = merge({"name" = "${var.db-name}-option-group",}, var.tags)
}

