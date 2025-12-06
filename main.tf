# -------- EC2 Instance Configuration -----------
provider "aws" {
    region = "us-east-2"
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
    vpc_security_group_ids = [aws_security_group.aws_sg.id]

    tags = {
        Name = "AWS Project Instance"
    }
}


# ----------- RDS Database Configuration -----------
resource "aws_security_group" "db_sg"{
    name = "Security_Group_AWS_Project_RDS_DB"
    description = "Security group for AWS Project Instance RDS Database, letting in only SSH traffic"

    ingress {
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        
    }

     vpc_security_group_ids = [aws_rds_security_group.aws_server_sg.id]
}

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


    vpc_security_group_ids = [aws_rds_security_group.db_sg.id]
}
 