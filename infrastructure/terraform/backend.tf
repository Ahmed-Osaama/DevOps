terraform {
  backend "s3" {
    bucket = "apnidukaan-terraform-state-661609780585-eu-central-1"

    key    = "apnidukaan/dev/terraform.tfstate"
    region = "eu-central-1"

    profile             = "apnidukaan"
    allowed_account_ids = ["661609780585"]

    encrypt      = true
    use_lockfile = true
  }
}
