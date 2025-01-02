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
    key = "terraform/state/terraform.tfstate"
    # Region where the bucket is located
    region = "us-east-1"
    # Match the DynamoDB table name created in backend.tf
    dynamodb_table = "kiosk-terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "tf_instance" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI
  instance_type = "t2.micro"

  tags = {
    Name = "Test-EC2-Instance"
  }
}
