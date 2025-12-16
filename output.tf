output "ec2_public_ip" {
  description = "Public access IP of the EC2 instance"
  value       = module.app-services.instance_public_ip
}

output "rds_endpoint" {
  description = "Database RDS Endpoint"
  value       = module.app-services.db_endpoint
}

output "site_frontend_url" {
  description = "S3 Bucket Website Endpoint"
  value       = module.frontend.s3_static_website_bucket_endpoint
}