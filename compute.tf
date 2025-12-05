# Declares the AWS provider
provider "aws" {
    region = "us-east-2"
}

# Declares the data resource to search for the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
    most_recent = true # searches for the most recent AMI available

    vpc_security_group_ids = [aws_security_group.aws_sg.id]

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
