locals {
  name_prefix = "${var.project_name}-${var.environment}"

  public_subnets = zipmap(
    var.availability_zones,
    var.public_subnet_cidrs
  )

  private_subnets = zipmap(
    var.availability_zones,
    var.private_subnet_cidrs
  )
}
