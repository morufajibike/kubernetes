######## AWS Secrets Manager test for CSI #########
resource "aws_secretsmanager_secret" "test_secret" {
  name        = "my-app-secret"
  description = "This is a secret used by my application"
}

resource "aws_secretsmanager_secret_version" "test_secret_value" {
  secret_id = aws_secretsmanager_secret.test_secret.id
  secret_string = jsonencode({
    username = "myuser"
    password = "mypassword123!"
  })
}
##################################################


