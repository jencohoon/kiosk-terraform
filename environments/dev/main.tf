terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    # Match the S3 bucket name already created in backend.tf
    bucket = "UPDATE-ME" # "kiosk-tf-s3-bucket"

    # Path in the bucket to store the state file
    key = "dev/terraform-state/terraform.tfstate"
    # Region where the bucket is located
    region = "us-east-1"
    # Match the DynamoDB table name created in backend.tf
    dynamodb_table = "kiosk-terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = var.env
      Name        = "managed-by-terraform-${var.env}"
    }
  }
}
