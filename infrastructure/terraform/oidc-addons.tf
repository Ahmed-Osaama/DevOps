# ==========================================
# EKS OIDC Provider
# ==========================================

locals {
  eks_oidc_issuer = trimprefix(
    aws_eks_cluster.main.identity[0].oidc[0].issuer,
    "https://"
  )
}

resource "aws_iam_openid_connect_provider" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]
}


# ==========================================
# Dedicated IAM Role for VPC CNI
# ==========================================

resource "aws_iam_role" "vpc_cni" {
  name = "${local.name_prefix}-vpc-cni-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "${local.eks_oidc_issuer}:aud" = "sts.amazonaws.com"

            "${local.eks_oidc_issuer}:sub" = "system:serviceaccount:kube-system:aws-node"
          }
        }
      }
    ]
  })

  tags = {
    Name = "${local.name_prefix}-vpc-cni-role"
  }
}

resource "aws_iam_role_policy_attachment" "vpc_cni" {
  role = aws_iam_role.vpc_cni.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}


# ==========================================
# VPC CNI Managed Add-on
# ==========================================

resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.main.name
  addon_name    = "vpc-cni"
  addon_version = "v1.22.4-eksbuild.14"

  service_account_role_arn = aws_iam_role.vpc_cni.arn

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"

  depends_on = [
    aws_iam_role_policy_attachment.vpc_cni
  ]
}


# ==========================================
# Kube Proxy Managed Add-on
# ==========================================

resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = aws_eks_cluster.main.name
  addon_name    = "kube-proxy"
  addon_version = "v1.37.0-eksbuild.39"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"
}


# ==========================================
# CoreDNS Managed Add-on
# ==========================================

resource "aws_eks_addon" "coredns" {
  cluster_name  = aws_eks_cluster.main.name
  addon_name    = "coredns"
  addon_version = "v1.14.7-eksbuild.35"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"
}
