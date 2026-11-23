# ==========================================
# ALB Security Group
# ==========================================

resource "aws_security_group" "alb" {
  name        = "${local.name_prefix}-alb-sg"
  description = "Allow public HTTP traffic to ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-alb-sg"
  }
}


# ==========================================
# Allow ALB to access Kubernetes NodePorts
# ==========================================

resource "aws_vpc_security_group_ingress_rule" "alb_to_nodes" {
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id

  referenced_security_group_id = aws_security_group.alb.id

  from_port   = 30080
  to_port     = 30081
  ip_protocol = "tcp"

  description = "Allow ALB traffic to Frontend and API Gateway NodePorts"
}


# ==========================================
# Application Load Balancer
# ==========================================

resource "aws_lb" "main" {
  name               = "${local.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    aws_subnet.public["eu-central-1a"].id,
    aws_subnet.public["eu-central-1b"].id
  ]

  enable_deletion_protection = false

  tags = {
    Name = "${local.name_prefix}-alb"
  }
}


# ==========================================
# Frontend Target Group
# ==========================================

resource "aws_lb_target_group" "frontend" {
  name        = "${local.name_prefix}-frontend-tg"
  port        = 30080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200-499"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${local.name_prefix}-frontend-tg"
  }
}


# ==========================================
# API Gateway Target Group
# ==========================================

resource "aws_lb_target_group" "api" {
  name        = "${local.name_prefix}-api-tg"
  port        = 30081
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200-499"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${local.name_prefix}-api-tg"
  }
}


# ==========================================
# HTTP Listener
# ==========================================

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}


# ==========================================
# API Gateway Routing Rule
# ==========================================

resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }

  condition {
    path_pattern {
      values = [
        "/api",
        "/api/*"
      ]
    }
  }
}


# ==========================================
# Attach Node Group to Target Groups
# ==========================================

resource "aws_autoscaling_attachment" "frontend" {
  autoscaling_group_name = aws_eks_node_group.main.resources[0].autoscaling_groups[0].name

  lb_target_group_arn = aws_lb_target_group.frontend.arn
}

resource "aws_autoscaling_attachment" "api" {
  autoscaling_group_name = aws_eks_node_group.main.resources[0].autoscaling_groups[0].name

  lb_target_group_arn = aws_lb_target_group.api.arn
}


# ==========================================
# ALB Output
# ==========================================

output "alb_dns_name" {
  description = "Public DNS name of ApniDukaan ALB"
  value       = aws_lb.main.dns_name
}
