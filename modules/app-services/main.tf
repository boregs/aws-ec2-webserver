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
    vpc_security_group_ids = [var.security_group_id_aws_server]

    tags = {
        Name = "${var.namePrefix}-ec2-instance"
    }

    user_data = file("${path.module}/userdata.sh")

    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
}

# IAM Role to allow EC2 to write logs to S3 Bucket
resource "aws_iam_role" "ec2_role" {
  name = "ec2_logs_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy to allow EC2 to write logs to S3 Bucket
resource "aws_iam_role_policy" "s3_write_policy" {
  name = "ec2_write_logs_policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",     
          "s3:ListBucket"     
        ]
        Resource = [
          aws_s3_bucket.bucket-logs.arn,
          "${aws_s3_bucket.bucket-logs.arn}/*"
        ]
      }
    ]
  })
}

# IAM Instance Profile to attach the Role to the EC2 Instance
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_logs_profile"
  role = aws_iam_role.ec2_role.name
}


# ----------- RDS Database Configuration -----------

resource "aws_db_instance" "default_rds_db" {
    identifier             = "database-aws-project"
    instance_class         = "db.t3.micro"
    allocated_storage      = 20
    engine                 = "postgres"
    engine_version         = "16.11"
    storage_type           = "gp2"

    username               = "postgres" # Replace with your desired username
    password               = var.rdsPassword # Replace with a secure password

    skip_final_snapshot    = true
    publicly_accessible    = false

    vpc_security_group_ids = [var.security_group_id_db]
}

# ------------- S3 Acess Logs Bucket Configuration -----------
resource "aws_s3_bucket" "bucket-logs" {
    bucket = "first-aws-bucket-deploy-uhuuuuuuuullegall" # Replace with a unique bucket name

    tags = {
        Name = "${var.namePrefix}-bucket-logs"
    }
}

resource "aws_s3_bucket_ownership_controls" "ownership-controls_s3_bucket-logs" {
    bucket = aws_s3_bucket.bucket-logs.id
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}

resource "aws_s3_bucket_public_access_block" "logs_block" {
  bucket = aws_s3_bucket.bucket-logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "s3-bucket" {
    depends_on = [aws_s3_bucket_ownership_controls.ownership-controls_s3_bucket-logs]

    bucket = aws_s3_bucket.bucket-logs.id
    acl    = "private"
}
 