output "current_account_id" {
  value       = data.aws_caller_identity.current.account_id
  description = "The account ID of the AWS CLI profile in use"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the VPC"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "IDs of the private subnets created"
}

