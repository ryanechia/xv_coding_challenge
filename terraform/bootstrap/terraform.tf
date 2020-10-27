variable "region" {
  default = "ap-southeast-1"
}

variable "namespace" {
  default = "xv-coding-challenge-ryane-c"
}

provider "aws" {
  region  = var.region
  version = "1.25.0"
}

provider "random" {
  version = "1.3.1"
}

module "config-state" {
  source              = "cloudowski/config-state/aws"
  version             = "0.2.0"
  region              = var.region
  bucket_name         = "${var.namespace}-tfstate"
  dynamodb_table_name = "${var.namespace}-tfstate"
}