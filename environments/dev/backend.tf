terraform {
  backend "s3" {
    bucket         = "aws-secure-vpc-terraform-state-elite-2026"
    key            = "dev/vpc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "aws-secure-vpc-terraform-locks"
    encrypt        = true
  }
}