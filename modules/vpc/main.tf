module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"
  
  name = var.name
  cidr = var.cidr

  azs             = var.azs
  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  tags = var.tags
}
