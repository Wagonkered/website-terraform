provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "acm_provider"
  region = "us-east-1"
}

terraform {
  required_version = ">=1.4.5"
  backend "s3" {
    bucket = "wagonkered-web-terraform-state"
    key    = "wagonkered.tfstate"
    region = "eu-west-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.65.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.3.0"
    }
  }
}

