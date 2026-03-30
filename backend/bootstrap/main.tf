resource "random_id" "suffix" {
  byte_length = 3
}

locals {
  name_prefix = "${var.project}-${var.environment}"
}

# =========================
# S3 BUCKET (Terraform State)
# =========================
resource "aws_s3_bucket" "tf_state" {
  bucket        = "${local.name_prefix}-tfstate-${random_id.suffix.hex}"
  force_destroy = var.force_destroy_bucket

  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Versioning (already good)
resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# UPGRADED ENCRYPTION (KMS instead of AES256)
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

# Public access block (already good)
resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# =========================
# DynamoDB (State Locking)
# =========================
resource "aws_dynamodb_table" "tf_lock" {
  name         = "${local.name_prefix}-tflock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  # NEW: Enable encryption
  server_side_encryption {
    enabled = true
  }

  # NEW: Enable point-in-time recovery (backup)
  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}