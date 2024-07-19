terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.26.0"
    }
  }
  required_version = ">= 1.2.0"
}

locals {
  write_access = [for user in var.users_with_write_access : "*${user}"]
  read_access  = [for user in var.users_with_read_access : "*${user}"]
}


resource "aws_secretsmanager_secret" "secret" {
  description = var.description
  name = var.secret_name

  tags = {
    Owners = join(", ", var.owners)
  }
}

resource "aws_secretsmanager_secret_policy" "policy" {
  secret_arn = aws_secretsmanager_secret.secret.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue"
        ]
        Resource = aws_secretsmanager_secret.secret.arn
        Principal = {
          AWS = "*"
        }
        Condition = {
          StringLike = {
            "aws:userId" = local.write_access
            "aws:PrincipalArn" = var.iam_roles_read_access
          }
        }
      },
       {
        Effect = "Deny"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = aws_secretsmanager_secret.secret.arn
        Principal = {
          AWS = "*"
        }
        Condition = {
          StringNotLike = {
            "aws:userId" = local.read_access
            "aws:PrincipalArn" = var.iam_roles_read_access
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:*"
        ]
        Resource = aws_secretsmanager_secret.secret.arn
        Principal = {
          AWS = "*"
        }
        Condition = {
          StringLike = {
            "aws:userId" = concat(local.write_access)
          }
        }
      }
    ]
  })
}
