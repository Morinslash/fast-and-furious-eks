data "aws_caller_identity" "current" {}

# Extract the email from the user_id and store it in a reusable local variable
locals {
  owner_email = element(split(":", data.aws_caller_identity.current.user_id), 1)
}

module "vpc" {
  source = "./vpc"

  cluster_name        = var.cluster_name
  cidr_block          = var.cidr_block
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
  tags = merge(var.tags, {
    Owner        = local.owner_email,
    ResourceType = "network"
  })
}

