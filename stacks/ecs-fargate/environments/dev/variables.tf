variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "container_port" {
  type    = number
  default = 80
}

variable "service_desired_count" {
  type    = number
  default = 1
}

variable "service_min_capacity" {
  type    = number
  default = 1
}

variable "service_max_capacity" {
  type    = number
  default = 3
}

variable "cpu_target_utilization" {
  type    = number
  default = 50
}
