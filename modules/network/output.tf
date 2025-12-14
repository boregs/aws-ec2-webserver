output "aws_sg_id_output" {
  description = "The ID of the security group"
  value = aws_security_group.aws_sg.id 
}

output "db_sg_id_output" {
  description = "The ID of the security group"
  value = aws_security_group.db_sg.id 
}

output "aws_server_public_ip_output" {
  description = "The public IP of the AWS server"
  value = aws_eip.s3_public_ip.public_ip
}