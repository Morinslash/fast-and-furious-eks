module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0" # Upgrade to the latest major version

  name = "${var.cluster_name}-vpc"
  cidr = var.cidr_block
  azs  = [var.availability_zone]

  private_subnets      = [var.private_subnet_cidr]
  enable_nat_gateway   = false
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = var.tags
}
