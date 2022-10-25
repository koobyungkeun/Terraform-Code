# RDS Mysql 데이터베이스 생성
resource "aws_db_instance" "rds_mysql" {
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "8.0.30"
  instance_class         = "db.t3.micro"
  username               = var.db_user
  password               = var.db_password
  skip_final_snapshot    = true
  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.rds_mysql_subnet_group.id
  vpc_security_group_ids = [aws_security_group.rds_mysql_sg.id]

  tags = {
    Name = "${var.name}_rds_mysql"
  }
}

# 데이터베이스 생성할 서브넷 그룹 생성
resource "aws_db_subnet_group" "rds_mysql_subnet_group" {
  subnet_ids = [aws_subnet.private_subnet2.0.id, aws_subnet.private_subnet2.1.id]

  tags = {
    Name = "${var.name}_rds_mysql_subnet_group"
  }
}

# 데이터베이스에 적용할 security group 생성
resource "aws_security_group" "rds_mysql_sg" {
  description = "Allow Mysql inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Mysql from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}_rds_mysql_sg"
  }
}
