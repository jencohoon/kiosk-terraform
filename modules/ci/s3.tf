# To store artifacts
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "kiosk-codepipeline-artifacts" # Change this to a globally unique bucket name
}
# Enable versioning for S3 bucket
resource "aws_s3_bucket_versioning" "versioning_codepipelien_bucket" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server side encryption for S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "codepipeline_bucket" {
  bucket = aws_s3_bucket.codepipeline_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}



resource "aws_s3_bucket" "codebuild_logs_bucket" {
  bucket = "kiosk-codebuild-logs" # Change this to a globally unique bucket name
}
# Enable versioning for S3 bucket
resource "aws_s3_bucket_versioning" "versioning_codebuild_logs_bucket" {
  bucket = aws_s3_bucket.codebuild_logs_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server side encryption for S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "codebuild_logs_bucket" {
  bucket = aws_s3_bucket.codebuild_logs_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
