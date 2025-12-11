output "aws_sg_id_output" {
  description = "The ID of the security group"
  value = aws_security_group.aws_sg.id 
}

output "db_sg_id_output" {
  description = "The ID of the security group"
  value = aws_security_group.db_sg.id 
}