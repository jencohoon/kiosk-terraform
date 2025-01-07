module "ci-setup" {
  source              = "../../modules/ci"
  ecr_repository_name = "test-container-repo"
  ec2_instance_name   = "Kiosk-EC2"
}
