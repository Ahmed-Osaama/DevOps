# ==========================================
# EKS Managed Node Group
# ==========================================

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${local.name_prefix}-workers"
  node_role_arn   = aws_iam_role.eks_nodes.arn

  # Deploy worker nodes in private subnets
  subnet_ids = [
    aws_subnet.private["eu-central-1a"].id,
    aws_subnet.private["eu-central-1b"].id
  ]

  # EC2 Configuration
  instance_types = ["t8i.small"]
  capacity_type  = "ON_DEMAND"
  disk_size      = 20

  # Node Scaling Configuration
  scaling_config {
    desired_size = 4
    min_size     = 2
    max_size     = 5
  }

  # Rolling Updates
  update_config {
    max_unavailable = 1
  }

  # Allow Cluster Autoscaler to manage desired capacity later
  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }

  tags = {
    Name        = "${local.name_prefix}-workers"
    Project     = "ApniDukaan"
    Environment = "Development"
  }

  depends_on = [
    aws_eks_addon.vpc_cni,
    aws_eks_addon.kube_proxy
  ]
}
