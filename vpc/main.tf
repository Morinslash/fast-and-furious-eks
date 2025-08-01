module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.cidr_block
  azs  = ["${var.availability_zone}", "${substr(var.availability_zone, 0, length(var.availability_zone) - 1)}b"] # Add second AZ

  private_subnets = [var.private_subnet_cidr, cidrsubnet(var.cidr_block, 8, 2)]              # Add second subnet
  public_subnets  = [cidrsubnet(var.cidr_block, 8, 101), cidrsubnet(var.cidr_block, 8, 102)] # Add public subnets

  enable_nat_gateway   = true # Required for EKS nodes in private subnets
  single_nat_gateway   = true # Cost optimization - single NAT for all AZs
  enable_dns_support   = true
  enable_dns_hostnames = true

  # EKS required tags
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = var.tags
}
