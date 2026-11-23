# ==========================================
# ECR Repositories for ApniDukaan Services
# ==========================================

locals {
  ecr_services = toset([
    "api-gateway",
    "auth-service",
    "cart-service",
    "catalog-service",
    "notification-service",
    "order-management-service",
    "order-service",
    "payment-service",
    "search-service",
    "user-service",
    "frontend"
  ])
}

# Create one repository for each service
resource "aws_ecr_repository" "services" {
  for_each = local.ecr_services

  name                 = "apnidukaan-${each.value}"
  image_tag_mutability = "MUTABLE"

  # Scan images when pushed
  image_scanning_configuration {
    scan_on_push = true
  }

  # Encryption at rest
  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name    = "apnidukaan-${each.value}"
    Service = each.value
  }
}

# ==========================================
# ECR Repository URLs
# ==========================================

output "ecr_repository_urls" {
  description = "ECR repository URLs for ApniDukaan services"

  value = {
    for service, repository in aws_ecr_repository.services :
    service => repository.repository_url
  }
}
