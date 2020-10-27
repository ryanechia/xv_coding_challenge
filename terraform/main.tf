
provider "aws" {
  region  = "us-east-1"
  version = "2.55"
}

provider "template" {
  version = "2.2"
}

terraform {
  backend "s3" {
    bucket         = "xv-coding-challenge-ryane-c-tfstate-zbez1uty"
    key            = "terraform"
    region         = "ap-southeast-1"
    dynamodb_table = "xv-coding-challenge-ryane-c-tfstate"
  }
}

module "microsite-bucket" {
  source  = "mineiros-io/s3-bucket/aws"
  version = "~> 0.4.0"

  bucket_prefix = "microsite"
  create_origin_access_identity = true
  access_points = [{ name = "microsite" }]

  versioning = true

  tags = {
    Name = "microsite S3 Bucket"
  }
}

resource "aws_cloudfront_distribution" "cloudfront" {
  origin {
    domain_name = module.microsite-bucket.bucket_domain_name
    origin_id   = "website"

    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = "80"
      https_port             = "443"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = [
      "HEAD",
      "GET",
    ]

    cached_methods = [
      "HEAD",
      "GET",
    ]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type = "origin-request"
      lambda_arn = module.lambda_edge_function.lambda_function_qualified_arn
    }

    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    target_origin_id       = "website"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

}

data "archive_file" "lambda_zip" {
    type          = "zip"
    source_dir   = "../lambda"
    output_path   = "/tmp/lambda.zip"
}

resource "aws_iam_role" "aws_iam_lambda_microsites3" {
  name = "aws_iam_lambda_microsites3"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

module "lambda_edge_function" {
  source = "dod-iac/lambda-edge-function/aws"

  execution_role_name = format(
    "app-%s-auth-redirect-lambda-execution-role-%s",
    var.application,
    local.environment
  )

  function_name = format(
    "app-%s-auth-redirect-%s",
    var.application,
    local.environment
  )

  function_description = "Okta auth redirect lambda."

  filename = "/tmp/lambda.zip"

  handler = "index.handler"

  runtime = "nodejs12.x"

  execution_role_policy_name = "aws_iam_lambda_microsites3"

  tags = {
    Application = var.application
    Environment = local.environment
    Automation  = "Terraform"
  }
}

data "aws_s3_bucket_object" "config" {
  bucket = "secret-bucket-9150959"
  key = "config.txt"
}
