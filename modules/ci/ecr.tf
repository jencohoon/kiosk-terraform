resource "aws_ecr_repository" "kiosk-container-repo" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "IMMUTABLE"

  # Encryption settings for a repository can't be changed after creation.
  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }
}
