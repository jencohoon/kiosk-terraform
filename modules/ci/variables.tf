variable "ecr_repository_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "ec2_instance_name" {
  description = "The name of the EC2 instance"
  type        = string
}

variable "github_oauth_token" {
  description = "The GitHub OAuth token"
  type        = string
  default     = "github_pat_from_secrets_manager" # fake token
}

variable "github_owner" {
  description = "GitHub owner (username or organization)"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "jencohoon/kiosk-terraform"
}

variable "github_branch" {
  description = "GitHub branch name to use in the pipeline"
  type        = string
}

variable "codebuild_logs_bucket" {
  description = "Name of the S3 bucket for CodeBuild logs"
  type        = string
}

variable "codepipeline_bucket" {
  description = "Name of the S3 bucket for CodePipeline artifacts"
  type        = string
}
