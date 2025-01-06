resource "aws_secretsmanager_secret" "github_oauth_token" {
  name        = "github_oauth_token_v2"
  description = "GitHub OAuth Token for CodeBuild"

  tags = {
    Name = "GitHub OAuth Token"
  }
}

resource "aws_secretsmanager_secret_version" "github_oauth_token_version" {
  secret_id     = aws_secretsmanager_secret.github_oauth_token.id
  secret_string = var.github_oauth_token
}
