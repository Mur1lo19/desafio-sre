resource "aws_db_subnet_group" "subnet_db" {
  name       = "subnet-rds"
  subnet_ids = [aws_subnet.my_private_db1.id, aws_subnet.my_private_db2.id]
}

resource "aws_db_instance" "my_rds" {
  allocated_storage           = 10
  db_name                     = "myrdspostgres"
  engine                      = "postgres"
  engine_version              = "16.2"
  instance_class              = "db.m5d.large"
  manage_master_user_password = true
  username                    = "dbadmin"
  vpc_security_group_ids      = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.subnet_db.name
  deletion_protection = false
#  skip_final_snapshot = true
}