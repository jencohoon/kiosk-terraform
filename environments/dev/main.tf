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
    bucket = "kiosk-tf-s3-bucket"
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
      Environment = "Dev"
      Name        = "managed-by-terraform"
    }
  }
}


resource "aws_s3_bucket" "codebuild_logs" {
  bucket = "kiosk-codebuild-logs"
}


resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "kiosk-codepipeline-artifacts"
}


resource "aws_iam_role" "codebuild_role" {
  name = "CodeBuildServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role" "codepipeline_new_role" {
  name = "CodePipelineServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codepipeline.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}
