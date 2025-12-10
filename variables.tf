variable "region" {
    description = "AWS region to deploy the resources"
    type = string
    default = "us-east-2"
}

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