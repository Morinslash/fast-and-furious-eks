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

module "eks" {
  source = "./eks"

  cluster_name        = var.cluster_name
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  node_instance_type  = var.node_instance_type
  desired_nodes       = var.desired_nodes
  kubernetes_version  = var.kubernetes_version
  public_access_cidrs = var.public_access_cidrs

  tags = merge(var.tags, {
    Owner        = local.owner_email,
    ResourceType = "compute"
  })

  depends_on = [module.vpc]
}
