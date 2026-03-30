locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "network" {
  source             = "./modules/network"
  name_prefix        = local.name_prefix
  vpc_cidr           = var.vpc_cidr
  az_count           = var.az_count
  enable_nat_gateway = var.enable_nat_gateway
}

module "security" {
  source      = "./modules/security"
  name_prefix = local.name_prefix
  vpc_id      = module.network.vpc_id
  vpc_cidr    = module.network.vpc_cidr
}

module "observability" {
  source      = "./modules/observability"
  name_prefix = local.name_prefix

  aws_region              = var.aws_region
  alb_arn_suffix          = module.alb.alb_arn_suffix
  target_group_arn_suffix = module.alb.target_group_arn_suffix

}

module "alb" {
  source            = "./modules/alb"
  name_prefix       = local.name_prefix
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
}

resource "aws_flow_log" "vpc" {
  log_destination_type = "cloud-watch-logs"
  log_destination      = module.observability.vpc_flowlog_log_group_arn
  iam_role_arn         = module.security.vpc_flowlog_role_arn
  traffic_type         = "ALL"
  vpc_id               = module.network.vpc_id
}

module "compute" {
  source      = "./modules/compute"
  name_prefix = local.name_prefix

  private_subnet_ids        = module.network.private_subnet_ids
  instance_type             = var.instance_type
  ec2_instance_profile_name = module.security.ec2_instance_profile_name
  app_sg_id                 = module.security.app_sg_id
  alarm_topic_arn           = module.observability.alarm_topic_arn

  asg_min = var.asg_min
  asg_max = var.asg_max

  target_group_arns = [module.alb.target_group_arn]
}
