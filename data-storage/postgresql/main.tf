
resource "aws_db_subnet_group" "default" {
  name       = "gitlab_bd_subnet_group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "GitLab DB Subnet"
  }
}

resource "aws_db_instance" "gitlab_postgres" {
  allocated_storage       = 5
  db_subnet_group_name    = aws_db_subnet_group.default.name
  deletion_protection     = true
  engine                  = "postgres"
  engine_version          = "11.5"
  instance_class          = "db.t2.micro"
  name                    = var.name
  username                = var.username
  password                = var.password
  port                    = 5432
  skip_final_snapshot     = true
  vpc_security_group_ids  = var.vpc_security_group_ids

  tags = {
    Name = "GitLab PostgreSQL RDS"
  }
}
