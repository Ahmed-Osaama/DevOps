# ==========================================
# Jenkins IAM User
# ==========================================

resource "aws_iam_user" "jenkins" {
  name = "${local.name_prefix}-jenkins-ecr-push"

  tags = {
    Name    = "${local.name_prefix}-jenkins-ecr-push"
    Purpose = "Jenkins ECR Image Push"
  }
}

# ==========================================
# Jenkins ECR Push Policy
# ==========================================

resource "aws_iam_policy" "jenkins_ecr_push" {
  name        = "${local.name_prefix}-jenkins-ecr-push-policy"
  description = "Allow Jenkins to push images to ApniDukaan ECR repositories"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid      = "ECRAuthorization"
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      },
      {
        Sid    = "PushImages"
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:BatchGetImage"
        ]

        Resource = [
          for repository in aws_ecr_repository.services :
          repository.arn
        ]
      }
    ]
  })
}

# ==========================================
# Attach Policy to Jenkins User
# ==========================================

resource "aws_iam_user_policy_attachment" "jenkins_ecr" {
  user       = aws_iam_user.jenkins.name
  policy_arn = aws_iam_policy.jenkins_ecr_push.arn
}
