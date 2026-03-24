# rds.tf

# Subnet group — RDS a besoin de 2 AZ minimum
resource "aws_db_subnet_group" "pixelwar_db_subnet_group" {
  name = "pixelwar-db-subnet-group"
  subnet_ids = [
    aws_subnet.pixelwar_indus_subnet.id,
    aws_subnet.pixelwar_production_subnet.id,
  ]
  tags = { Name = "pixelwar-db-subnet-group" }
}

# Security Group RDS — autorise uniquement les EC2 prod
resource "aws_security_group" "rds_sg" {
  name   = "pixelwar-rds-sg"
  vpc_id = aws_vpc.pixelwar_vpc.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.prod_sg.id,aws_security_group.indus_sg.id]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "pixelwar-rds-sg" }
}

# Instance RDS PostgreSQL
resource "aws_db_instance" "pixelwar_postgres" {
  identifier        = "pixelwar-db"
  engine            = "postgres"
  engine_version    = "15"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = "pixelwar"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.pixelwar_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false
  skip_final_snapshot = true

  tags = { Name = "pixelwar-postgres" }
}