variable "cluster_name" {
  description = "Name of the EKS cluster or project"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.1.0/24" # Single private subnet
}

variable "availability_zone" {
  description = "Availability zone to deploy the private subnet"
  type        = string
  default     = "eu-west-1a"
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
}
