resource "aws_secretsmanager_secret" "app" {
  name                    = "dev/app/secrets"
  description             = "Application secrets for dev ECS Fargate service"
  recovery_window_in_days = 7

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

resource "aws_secretsmanager_secret_version" "app" {
  secret_id = aws_secretsmanager_secret.app.id

  secret_string = jsonencode({
    DB_PASSWORD = "placeholder-replace-after-apply"
    API_KEY     = "placeholder-replace-after-apply"
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}