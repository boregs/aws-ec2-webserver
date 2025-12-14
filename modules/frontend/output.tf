output "s3_static_website_bucket_endpoint" {
  description = "the ID of the S3 bucket for the static website frontend"
  value       = aws_s3_bucket.aws-s3-static-website-bucket.website_endpoint
}