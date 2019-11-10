
resource "aws_db_subnet_group" "default" {
  name       = "gitlab_bd_subnet_group"
  subnet_ids = [aws_subnet.rds1.id, aws_subnet.rds2.id]

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
  name                    = "gitlab"
  username                = "postgres"
  password                = var.gitlab_db_master_pass  // TODO: Sure exists better way to manage passwords
                                                            // TODO: Concider to use AWS Secret  Manager
  skip_final_snapshot     = true
  port                    = 5432
  vpc_security_group_ids  = [data.aws_security_group.default.id]
  tags = {
    Name = "GitLab PostgreSQL RDS"
  }
}
