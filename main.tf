terraform {
  backend "s3" {
    bucket         = "kiosk-tf-s3-bucket" # Match the S3 bucket name created in backend.tf
    key            = "terraform/state/terraform.tfstate" # Path in the bucket to store the state file
    region         = "us-east-1" # Region where the bucket is located
    dynamodb_table = "kiosk-terraform-state-lock" # Match the DynamoDB table name created in backend.tf
    encrypt        = true
  }
}



resource "aws_instance" "tf_instance" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI
  instance_type = "t2.micro"

  tags = {
    Name = "Test-EC2-Instance"
  }
}
