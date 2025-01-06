module "ci-setup" {
  source              = "../../modules/ci"
  ecr_repository_name = "test-container-repo"
  ec2_instance_name   = "Kiosk-EC2"

  codebuild_logs_bucket = "kiosk-codebuild-logs"
  codepipeline_bucket   = "kiosk-codepipeline-artifacts"
  github_oauth_token    = "fake-token"
  github_owner          = "Verma97"
  github_repo           = "jencohoon/kiosk-terraform"
  github_branch         = "main"
}
