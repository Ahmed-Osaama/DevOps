output "vpc_id" {
  description = "ID of the ApniDukaan VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the ApniDukaan VPC"
  value       = aws_vpc.main.cidr_block
}
