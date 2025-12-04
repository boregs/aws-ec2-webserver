
resource "aws_security_group" "aws_sg"{
    name = "Security_Group_AWS_Project"
    description = "Security group for AWS Project Instance, letting in SSH and HTTP traffic"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cdir_blocks = ["177.10.20.30/32"] # Ips allowed to access via SSH | Fake IP, replace with your own
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cdir_blocks = ["?"] # Ips allowed to access via HTTP
    }
 
    egress {
        cdir_blocks = ["?"] # Ips allowed to exit the instance
    }
}