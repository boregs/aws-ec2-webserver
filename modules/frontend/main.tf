#--- Creates the s3 bucket for hosting the static website frontend ---#
resource "aws_s3_bucket" "aws_s3_static_website_bucket" {
    bucket = "${var.namePrefix}-fronted_end_bucket_2025_boregs" # Replace with a unique bucket name

    tags = {
        Name = "${var.namePrefix}-fronted-end-bucket"
    }
}

#--- Configures the S3 bucket for static website hosting, giving the .html documents to it ---#
resource "aws_s3_bucket_configuration" "s3_static_config" {
    bucket = aws_s3_bucket.aws_s3_static_website_bucket.id

    website {
        index_document = "index.html"
        error_document = "error.html"
    }
}

#--- Sets the S3 bucket policy to allow public read access to the website content ---#
resource "aws_s3_bucket_public_access_block" "s3_access_block" {
  bucket = aws_s3_bucket.aws_s3_static_website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#--- S3 Bucket Policy to allow public read access ---#
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
    bucket = aws_s3_bucket.aws_s3_static_website_bucket.id # Links the policy to the S3 bucket

    policy = jsonencode({ # Converts the Terraform code to a JSON, since AWS only accepts JSON for policies
        Version = "2012-10-17"
        Statement = [   # Opens the list of "rules" for the policy
            {
                Sid       = "PublicReadGetObject"  # Statement ID, basically the name of the rule
                Effect    = "Allow" # Defines what we are doing allowing or denying
                Principal = "*" # Defines who is affected, "*" means everyone
                Action    = "s3:GetObject" # Defines what actions can be done by who, GetObject means read access (allows visitors to see the website bruv)
                Resource  = "${aws_s3_bucket.aws_s3_static_website_bucket.arn}/*"  # Defines to which resource the policy applies (the /* at the end means all objects inside the bucket)
            }
        ]
    })
}