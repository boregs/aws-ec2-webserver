resource "aws_security_group" "aws_sg"{
    name = "Security_Group_AWS_Project"
    description = "Security group for AWS Project Instance, letting in SSH and HTTP traffic"

    ingress {
        from_port = var.ssh_port
        to_port = var.ssh_port
        protocol = var.protocol
        cidr_blocks = ["177.10.20.30/32"] # Ips allowed to access via SSH | Fake IP, replace with your own
    }

    ingress {
        from_port = var.http_port
        to_port = var.http_port
        protocol = var.protocol
        cidr_blocks = ["0.0.0.0/0"] # Ips allowed to access via HTTP
    }
 
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"] # Ips allowed to exit the instance
    }
}

resource "aws_security_group" "db_sg"{
    name = "Security_Group_AWS_Project_RDS_DB"
    description = "Security group for AWS Project Instance RDS Database, letting in only SSH traffic"

    ingress {
        from_port = var.ssh_port
        to_port = var.rds_port
        protocol = var.protocol
        
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"] # Ips allowed to exit the database
    }
}

resource "aws_eip" "s3_public_ip" {

  tags = {
    Name = "AWS_S3_Public_IP"
  }
}