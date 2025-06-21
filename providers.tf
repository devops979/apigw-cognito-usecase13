terraform {
  required_version = ">= 1.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.99.1"
    }
  }

  backend "s3" {
    bucket       = "demo-usecases-bucket-new"
    key          = "usecase-13/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true # New approach for state locking
  }
}



provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = terraform.workspace
      Project     = "hello-world-lambda"
      ManagedBy   = "Terraform"
    }
  }
}