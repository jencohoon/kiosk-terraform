module "ci-setup" {
  source              = "../../modules/ci"
  ecr_repository_name = "test-container-repo"
  ec2_instance_name   = "Kiosk-EC2"
}

resource "aws_codebuild_project" "terraform_build" {
  name         = "TerraformBuild"
  service_role = aws_iam_role.codebuild_role.arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "modules/ci/buildspec.yml" # Ensure the path to your buildspec.yml is correct
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "SECRET_NAME"
      value = "dev-db-credentials" # Replace with the actual secret name
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
      location = "${aws_s3_bucket.codebuild_logs.id}/build-log"
    }
  }
}

resource "aws_codepipeline" "codepipeline" {
  name     = "tf-test-pipeline"
  role_arn = aws_iam_role.codepipeline_new_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = "kiosk-terraform" # Replace with your GitHub repo name
        Branch         = "main"
        OAuthToken     = var.github_token # Securely stored OAuth token for GitHub
      }
    }
  }

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
        ProjectName = aws_codebuild_project.terraform_build.name # Replace with your CodeBuild project name
      }
    }
  }
}

