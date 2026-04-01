module "vpc" {
  source = "../../modules/vpc"

  name = "aws-secure-vpc-dev"
  cidr = "10.10.0.0/16"

  azs = ["us-east-1a", "us-east-1b"]

  public_subnet_cidrs  = ["10.10.0.0/24", "10.10.1.0/24"]
  private_subnet_cidrs = ["10.10.10.0/24", "10.10.11.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = "dev"
    Project     = "aws-secure-vpc-terraform"
    ManagedBy   = "Terraform"
  }
}

module "alb" {
  source = "../../modules/alb"

  name_prefix       = "dev"
  public_subnet_ids = module.vpc.public_subnet_ids
  vpc_id            = module.vpc.vpc_id  

  alb_sg_id = aws_security_group.alb.id

  certificate_arn = var.certificate_arn
  log_bucket_name = var.log_bucket_name  
}