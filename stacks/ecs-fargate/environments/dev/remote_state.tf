data "terraform_remote_state" "platform" {
  backend = "s3"
  config = {
    bucket       = "aws-secure-vpc-terraform-shared-tfstate-b697ea"
    region       = var.aws_region
    key          = "dev/vpc/terraform.tfstate"
    use_lockfile = true
  }
}
