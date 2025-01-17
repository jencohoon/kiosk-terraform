# CodeBuild Project
resource "aws_codebuild_project" "terraform_build" {
  name         = "TerraformBuild"
  service_role = aws_iam_role.codebuild_role.arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "modules/ci/buildspec.yml"
  }

  artifacts {
    type      = "CODEPIPELINE"
    packaging = "ZIP"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "GITHUB_OAUTH_TOKEN"
      value = aws_secretsmanager_secret.github_oauth_token.secret_string # Use the secret string, not the ID
      type  = "SECRETS_MANAGER"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "codebuild-logs"
      stream_name = "build-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${var.codebuild_logs_bucket}/build-log"
    }
  }
}

# CodePipeline Resource
resource "aws_codepipeline" "codepipeline" {
  name     = "tf-test-pipeline"
  role_arn = aws_iam_role.codepipeline_new_role.arn

  # Artifact Store Configuration
  artifact_store {
    type     = "S3"
    location = var.codepipeline_bucket
  }

  # Source Stage (GitHub integration with OAuth token stored in Secrets Manager)
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "GitHub" # Use GitHub directly
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = var.github_owner                                           # GitHub account or organization name
        Repo       = var.github_repo                                            # GitHub repository name
        Branch     = var.github_branch                                          # Branch to trigger on (e.g., "main")
        OAuthToken = aws_secretsmanager_secret.github_oauth_token.secret_string # Reference the GitHub token from Secrets Manager
      }
    }
  }

  # Build Stage
  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.terraform_build.name
      }
    }
  }
}
