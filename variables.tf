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