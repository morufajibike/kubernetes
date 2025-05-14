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

#### IAM for service account that pod will use to get aws secret from secrets manager
resource "aws_iam_policy" "secretsmanager_access" {
  name        = "SecretsManagerReadAccess"
  description = "Allow read access to Secrets Manager"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
        Resource = "arn:aws:secretsmanager:${var.account_region}:${var.account_id}:secret:my-app-secret*"
      }
    ]
  })
}

resource "aws_iam_role" "irsa_role" {
  name = "secretsmanager-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.this.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:default:irsa-enabled-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.irsa_role.name
  policy_arn = aws_iam_policy.secretsmanager_access.arn
}

resource "kubernetes_service_account" "irsa" {
  metadata {
    name      = "irsa-enabled-sa"
    namespace = "default"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.irsa_role.arn
    }
  }
}
