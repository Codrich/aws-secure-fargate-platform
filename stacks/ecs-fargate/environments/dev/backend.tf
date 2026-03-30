terraform {
  backend "s3" {
    bucket         = "aws-secure-vpc-terraform-shared-tfstate-b697ea"
    key            = "ecs/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "aws-secure-vpc-terraform-shared-tflock"
    encrypt        = true
  }
}
