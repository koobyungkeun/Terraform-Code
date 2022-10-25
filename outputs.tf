output "bastion_eip" {
  description = "bastion 접속 ip"
  value       = aws_eip.bastion_eip.public_ip
}

output "rds_mysql_endpoint" {
  description = "database 접속 endpoint"
  value       = aws_db_instance.rds_mysql.endpoint
}
