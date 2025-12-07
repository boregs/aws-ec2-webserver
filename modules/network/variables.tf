variable "protocol" {
    description = "The protocol to allow"
    type = string
    default = "tcp"
}

variable "rds_port" {
    description = "The port for RDS database"
    type = number
    default = 5432
}

variable "ssh_port" {
    description = "SSH port"
    type = number
    default = 22
}

variable "http_port" {
    description = "HTTP port"
    type = number
    default = 80
}
