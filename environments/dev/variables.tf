variable "environment" {
  description = "The deployment environment: dev, sqa, preprod, or prod"
  type        = string
}

variable "github_token" {
  description = "GitHub OAuth token for accessing repositories"
  type        = string
  default     = "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"
}

variable "secret_name" {
  description = "The name of the secret to use in CodeBuild"
  type        = string
  default     = "dev-db-credentials"
}

