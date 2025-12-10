variable "rdsPassword"{
    description = "The RDS database password"
    type = string
    sensitive = true
}

variable "namePrefix" {
    description = "Prefix for naming AWS resources"
    type        = string
    default     = "AWSProject"
}

variable "region" {
    description = "AWS region to deploy the resources"
    type = string
    default = "us-east-2"
}

variable "security_group_id_aws_server" {
  description = "The ID of the security group to the EC2 instance"
  type        = string
}

variable "security_group_id_db" {
  description = "The ID of the security group to the RDS database"
  type        = string
}