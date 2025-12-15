output "instance_public_ip" {
  description = "EC2 Instance Public IP"
  value       = aws_instance.aws_server.public_ip
}

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.aws_server.id
}

output "db_endpoint" {
  description = "RDS Database Endpoint"
  value       = aws_db_instance.default_rds_db.endpoint
}