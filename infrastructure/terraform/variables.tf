variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "apnidukaan"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the main VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "availability_zones" {
  description = "Availability Zones used by the infrastructure"
  type        = list(string)

  default = [
    "eu-central-1a",
    "eu-central-1b"
  ]

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Exactly two Availability Zones must be configured."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)

  default = [
    "10.20.0.0/24",
    "10.20.1.0/24"
  ]

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Exactly two public subnet CIDRs are required."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)

  default = [
    "10.20.16.0/20",
    "10.20.32.0/20"
  ]

  validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "Exactly two private subnet CIDRs are required."
  }
}
