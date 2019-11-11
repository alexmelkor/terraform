
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
  engine                  = "postgres"
  engine_version          = "11.5"
  instance_class          = "db.t2.micro"
  name                    = var.username
  username                = var.password
  password                = var.password
  skip_final_snapshot     = true
  port                    = 5432
  vpc_security_group_ids  = var.vpc_security_group_ids
  tags = {
    Name = "GitLab PostgreSQL RDS"
  }
}
