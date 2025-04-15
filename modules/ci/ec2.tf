resource "aws_instance" "tf_instance" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI
  instance_type = "t2.micro"

  tags = {
    Name = var.ec2_instance_name
  }
}

# IJKL this is a comment 2 for chery-pick test
