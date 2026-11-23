# ==========================================
# Amazon EKS Cluster
# ==========================================

resource "aws_eks_cluster" "main" {
  name     = "${local.name_prefix}-eks"
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.37"

  # Control Plane Logging
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator"
  ]

  # Authentication Configuration
  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  # Network Configuration
  vpc_config {
    subnet_ids = [
      aws_subnet.private["eu-central-1a"].id,
      aws_subnet.private["eu-central-1b"].id
    ]

    endpoint_private_access = true
    endpoint_public_access  = true

    public_access_cidrs = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-eks"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster,
    aws_cloudwatch_log_group.eks
  ]
}