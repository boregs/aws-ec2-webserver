# -------- EC2 Instance Configuration -----------
provider "aws" {
    region = var.region
}

data "aws_ami" "ubuntu" {
    most_recent = true # searches for the most recent AMI available

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    owners = ["099720109477"] # The ID of the official AWS Ubuntu image provider
}


 
# Declares the EC2 instance resource
resource "aws_instance" "aws_server" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t3.micro"

    # Adds to the instance the security group created in aws_security_group.tf
    vpc_security_group_ids = [module.network.main.aws_sg.id]

    tags = {
        Name = var.namePrefix + "_EC2_Instance"
    }
}

# ----------- RDS Database Configuration -----------

resource "aws_db_instance" "default_rds_db" {
    identifier             = "database-aws-project"
    instance_class         = "db.t3.micro"
    allocated_storage      = 20
    engine                 = "postgres"
    engine_version         = "16.3"
    storage_type           = "gp2"

    username               = "posgres" # Replace with your desired username
    password               = var.rds_password # Replace with a secure password

    skip_final_snapshot    = true
    publicly_accessible    = false


    vpc_security_group_ids = [module.network.main.db_sg.id]
}
 