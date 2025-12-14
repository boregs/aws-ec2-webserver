variable "namePrefix" {
    description = "Prefix for naming AWS resources"
    type        = string
    default     = "AWSProject"
}

variable "aws_server_public_ip" {
    description = "Public IP address of the AWS server"
    type = string
}