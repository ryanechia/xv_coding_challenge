output "bucket_name" {
  value = module.microsite-bucket.id
}

output "cloudfront_url" {
  value       = try(aws_cloudfront_distribution.cloudfront.domain_name, "")
  description = "domain name of CloudFront distribution"
}

output "okta_api_key" {
  value = try(data.aws_s3_bucket_object.config.body,"")
}