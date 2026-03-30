variable "name_prefix" { type = string }
variable "asg_name" {
  type    = string
  default = null
}

variable "alb_arn_suffix" {
  type = string
}

variable "target_group_arn_suffix" {
  type = string
}

variable "aws_region" {
  type = string
}
