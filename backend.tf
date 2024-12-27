provider "aws" {
  region = "us-east-1"
}

# Create IAM Role for Terraform
resource "aws_iam_role" "terraform_user" {
  name = "terraform-user"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Create a Policy for S3 and DynamoDB Access
resource "aws_iam_policy" "terraform_policy" {
  name        = "terraform-access-policy"
  description = "Policy to restrict access to Terraform resources"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = [
          "arn:aws:s3:::kiosk-tf-s3-bucket",
          "arn:aws:s3:::kiosk-tf-s3-bucket/*"
        ]
      },
      {
        Effect   = "Allow",
        Action   = ["dynamodb:*"],
        Resource = "arn:aws:dynamodb:us-east-1:*:table/kiosk-terraform-state-lock"
      }
    ]
  })
}

# Attach the Policy to the Role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.terraform_user.name
  policy_arn = aws_iam_policy.terraform_policy.arn
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
