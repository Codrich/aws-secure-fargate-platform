variable "allowed_ingress_cidr" {
  type        = string
  description = "CIDR allowed to access the ALB (dev). Use your public IP /32."
  default     = "131.226.16.4/32"
}

variable "alb_listener_port" {
  type    = number
  default = 80
}

variable "target_port" {
  type    = number
  default = 80
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "dev_domain_name" {
  type        = string
  description = "DNS name for the dev ALB, e.g. dev.mertmart.com"
}

# ADD THESE
variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener"
  type        = string
}

variable "log_bucket_name" {
  description = "S3 bucket for ALB access logs"
  type        = string
}