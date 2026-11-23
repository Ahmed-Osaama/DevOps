# ==========================================
# EKS Control Plane CloudWatch Log Group
# ==========================================

resource "aws_cloudwatch_log_group" "eks" {
  name = "/aws/eks/${local.name_prefix}-eks/cluster"

  retention_in_days = 7

  tags = {
    Name = "${local.name_prefix}-eks-logs"
  }
}
