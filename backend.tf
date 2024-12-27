provider "aws" {
  region = "us-east-1"
}

# Create an S3 bucket
resource "aws_s3_bucket" "tf_bucket" {
  bucket = "kiosk-tf-s3-bucket" # Change this to a globally unique bucket name
}

resource "aws_s3_bucket_versioning" "versioning_tf_bucket" {
  bucket = aws_s3_bucket.tf_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_bucket" {
  bucket = aws_s3_bucket.tf_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Create a DynamoDB table for state locking
resource "aws_dynamodb_table" "tf_state_lock" {
  name         = "kiosk-terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
