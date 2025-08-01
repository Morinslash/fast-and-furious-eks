variable "region" {
  description = "AWS region"
  default     = "eu-west-1"
}

variable "profile" {
  description = "AWS profile"
  default     = "default"
}

variable "cluster_name" {
  description = "Name of the EKS cluster or project"
  type        = string
  default     = "eks-lab"
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.1.0/24" # Adjust if necessary
}

variable "availability_zone" {
  description = "Availability zone to deploy the private subnet"
  type        = string
  default     = "eu-west-1a"
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS nodes"
  type        = string
  default     = "t3.medium"
}

variable "desired_nodes" {
  description = "Desired number of EKS worker nodes"
  type        = number
  default     = 3
}

variable "kubernetes_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.31"
}

variable "public_access_cidrs" {
  description = "List of CIDR blocks that can access the public API endpoint of the cluster"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "terraform",
  }
}
