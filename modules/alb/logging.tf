# S3 Bucket for ALB Access Logs
resource "aws_s3_bucket" "alb_logs" {
  bucket = var.log_bucket_name

  tags = {
    Name = "${var.name_prefix}-alb-logs"
  }
}

# Enable versioning - fixes CKV_AWS_21
resource "aws_s3_bucket_versioning" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Bucket policy so ELB can write logs
resource "aws_s3_bucket_policy" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "elasticloadbalancing.amazonaws.com" }
      Action    = "s3:PutObject"
      Resource  = "${aws_s3_bucket.alb_logs.arn}/*"
      Condition = {
        StringEquals = {
          "aws:SourceAccount" = data.aws_caller_identity.current.account_id
        }
      }
    }]
  })
}

# Skip cross-region replication check for log bucket (common & reasonable for ALB logs)
#checkov:skip=CKV_AWS_144:Cross-region replication not required for ALB access log bucket