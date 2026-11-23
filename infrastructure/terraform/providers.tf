provider "aws" {
  profile = "apnidukaan"
  region  = "eu-central-1"

  allowed_account_ids = [
    "661609780585"
  ]

  default_tags {
    tags = {
      Project     = "ApniDukaan"
      Environment = "Development"
      ManagedBy   = "Terraform"
      Team        = "DevOps"
    }
  }
}
