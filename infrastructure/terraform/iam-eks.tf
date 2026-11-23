# ==========================================
# EKS Cluster IAM Role
# ==========================================

resource "aws_iam_role" "eks_cluster" {
  name = "${local.name_prefix}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "eks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${local.name_prefix}-eks-cluster-role"
  }
}

# Attach Cluster Policy
resource "aws_iam_role_policy_attachment" "eks_cluster" {
  role = aws_iam_role.eks_cluster.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


# ==========================================
# EKS Worker Nodes IAM Role
# ==========================================

resource "aws_iam_role" "eks_nodes" {
  name = "${local.name_prefix}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${local.name_prefix}-eks-node-role"
  }
}

# Attach Worker Node Policy
resource "aws_iam_role_policy_attachment" "eks_nodes_worker" {
  role = aws_iam_role.eks_nodes.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Attach ECR Pull Only Policy
resource "aws_iam_role_policy_attachment" "eks_nodes_ecr" {
  role = aws_iam_role.eks_nodes.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}
