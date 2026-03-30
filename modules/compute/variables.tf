variable "name_prefix" { type = string }

variable "private_subnet_ids" { type = list(string) }
variable "instance_type" { type = string }
variable "ec2_instance_profile_name" { type = string }
variable "app_sg_id" { type = string }

variable "asg_min" {
  type    = number
  default = 1
}

variable "asg_max" {
  type    = number
  default = 1
}

variable "alarm_topic_arn" {
  type = string
}

variable "target_group_arns" {
  type    = list(string)
  default = []
}
