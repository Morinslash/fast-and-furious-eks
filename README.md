# **Fast and Furious EKS Terraform Repository**

## **Purpose**
This repository is designed to deploy AWS EKS clusters with underlying VPC infrastructure for testing and experimentation purposes. The repository now implements:
- **VPC** creation with private and public subnets across multiple availability zones
- **EKS cluster** deployment with configurable node groups
- **kubectl access** configuration for local development
- **Automatic resource tagging** based on AWS CLI user identity

---

## **Current Infrastructure**

### **Implemented Components**
- ✅ **VPC Module**: Creates VPC with public/private subnets using terraform-aws-modules/vpc/aws (~> 5.0)
- ✅ **EKS Module**: Deploys managed EKS cluster with node groups
- ✅ **IAM Roles**: Cluster and node group IAM roles with required policies
- ✅ **EKS Addons**: CoreDNS, kube-proxy, and VPC CNI
- ✅ **Resource Tagging**: Automatic owner identification and consistent tagging

### **Architecture**
- **VPC**: Configurable CIDR block (default: 10.0.0.0/16)
- **Subnets**: Private and public subnets across 2 AZs
- **NAT Gateway**: Single NAT gateway for private subnet internet access
- **EKS Cluster**: Managed Kubernetes cluster with public API endpoint
- **Node Groups**: Auto-scaling node groups with configurable instance types

---

## **AWS Profile Setup and AWS CLI Login**

### **AWS CLI SSO Login**
If using AWS Single Sign-On, authenticate with AWS CLI by running:

```bash
aws sso login --profile your-profile-name
```

This command opens a browser for authentication and grants access to the specified AWS profile.

### **Profile Configuration**
The Terraform configuration uses AWS profiles for authentication. To ensure the profile is set up correctly:
1. Configure the profile in your AWS CLI at `~/.aws/config`:
   ```ini
   [profile your-profile-name]
   sso_start_url = https://your-org.awsapps.com/start
   sso_region = eu-west-1
   sso_account_id = 123456789012
   sso_role_name = YourRoleName
   region = eu-west-1
   ```
2. After configuration, log in using `aws sso login --profile your-profile-name`.

---

## **Variable Management**

### **Default Configuration**
The repository is pre-configured with the following defaults:
- **Region**: `eu-west-1`
- **Cluster Name**: `eks-lab`
- **VPC CIDR**: `10.0.0.0/16`
- **Private Subnet CIDR**: `10.0.1.0/24`
- **Availability Zone**: `eu-west-1a`
- **Node Instance Type**: `t3.medium`
- **Desired Nodes**: `3`
- **Kubernetes Version**: `1.31`
- **Public Access CIDRs**: `["0.0.0.0/0"]` (⚠️ Restrict in production)

### **Customizing Variables**
1. Clone the example variables file for customization:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
2. Edit `terraform.tfvars` to provide your specific configuration:
   ```hcl
   profile = "your-aws-profile"
   region = "eu-west-1"
   cluster_name = "my-eks-lab"
   cidr_block = "10.0.0.0/16"
   private_subnet_cidr = "10.0.1.0/24"
   availability_zone = "eu-west-1a"
   
   # EKS specific variables
   node_instance_type = "t3.medium"
   desired_nodes = 3
   kubernetes_version = "1.31"
   public_access_cidrs = ["YOUR_IP/32"]  # Replace with your IP
   ```

---

## **Resource Tagging**

The infrastructure automatically applies tags to all resources:
- **ManagedBy**: "terraform"
- **Owner**: Extracted from AWS CLI user identity
- **ResourceType**: Applied per module (e.g., "network" for VPC, "compute" for EKS)

---

## **State Management**
- Terraform uses **local state** for managing the infrastructure.
- State files, such as `terraform.tfstate` and `.terraform/` directories, are ignored in version control through `.gitignore`.

Because this project is for temporary lab environments, no remote state management is configured (e.g., S3 and DynamoDB). For production usage, consider adding a remote backend.

---

## **Deployment Commands**

### **Basic Terraform Workflow**

1. **Initialize Terraform:**
   Downloads provider plugins and configures the working directory.
   ```bash
   terraform init
   ```

2. **Plan Infrastructure:**
   Generates a plan of changes required to achieve the desired state.
   ```bash
   terraform plan
   ```

3. **Apply Infrastructure:**
   Applies the plan and creates the VPC and EKS infrastructure.
   ```bash
   terraform apply
   ```

4. **Configure kubectl:**
   After deployment, update your kubeconfig to access the cluster.
   ```bash
   # The command is output by Terraform, but typically:
   aws eks update-kubeconfig --region eu-west-1 --name eks-lab
   ```

5. **Destroy Infrastructure:**
   Destroys all resources defined by Terraform.
   ```bash
   terraform destroy
   ```

### **Best Practice: Plan Files**

For better review and control:
```bash
# Generate a plan file
terraform plan -out=tfplan

# Review the plan
terraform show tfplan

# Apply the specific plan
terraform apply tfplan
```

### **Additional Commands**

- **Validate the Configuration:**
  ```bash
  terraform validate
  ```

- **Format Terraform Files:**
  ```bash
  terraform fmt
  ```

- **Test kubectl access:**
  ```bash
  kubectl get nodes
  kubectl get pods --all-namespaces
  ```

---

## **Outputs**

After successful deployment, Terraform provides the following outputs:
- **current_account_id**: AWS account ID of the CLI profile in use
- **vpc_id**: ID of the created VPC
- **private_subnet_ids**: IDs of the private subnets created
- **cluster_endpoint**: EKS cluster API endpoint
- **cluster_name**: Name of the EKS cluster
- **update_kubeconfig**: Command to configure kubectl access

---

## **Security Considerations**

1. **API Access**: By default, the EKS API endpoint is publicly accessible. Use `public_access_cidrs` to restrict access to specific IPs:
   ```hcl
   public_access_cidrs = ["YOUR_IP/32"]
   ```

2. **NAT Gateway**: The VPC uses a single NAT gateway for cost optimization. For production, consider multi-AZ NAT gateways.

3. **Node Security**: Nodes are deployed in private subnets and access the internet through NAT gateway.

---

## **Module Structure**
```
├── main.tf                    # Root configuration with module calls
├── variables.tf               # Global variables
├── outputs.tf                 # Root outputs
├── provider.tf               # AWS provider configuration
├── terraform.tfvars.example  # Example variables
├── vpc/                      # VPC module (implemented)
│   ├── main.tf              # VPC configuration
│   ├── variables.tf         # VPC variables
│   └── outputs.tf           # VPC outputs
└── eks/                      # EKS module (implemented)
    ├── main.tf              # EKS cluster, node groups, and addons
    ├── variables.tf         # EKS variables
    ├── outputs.tf           # EKS outputs
    └── locals.tf            # Local values and data sources
```

---

## **Common Use Cases**

### **Port Forwarding for Development**
Access services running in the cluster without exposing them publicly:
```bash
# Forward local port 8080 to a service
kubectl port-forward service/my-service 8080:80

# Forward to a specific pod
kubectl port-forward pod/my-pod 8080:8080
```

### **Scaling Nodes**
```bash
# Update the number of nodes
terraform apply -var="desired_nodes=5"
```

### **Updating Kubernetes Version**
```bash
# Check available versions in your region
aws eks describe-addon-versions --query 'addons[0].addonVersions[*].compatibilities[*].clusterVersion' | jq -r '.[]' | sort -u

# Update to a new version
terraform apply -var="kubernetes_version=1.32"
```

---

## **Troubleshooting**

### **kubectl Connection Issues**
- Ensure your IP is in `public_access_cidrs`
- Verify AWS credentials: `aws sts get-caller-identity`
- Update kubeconfig: `aws eks update-kubeconfig --region <region> --name <cluster-name>`

### **Node Issues**
- Check node status: `kubectl get nodes`
- View node logs: `kubectl describe node <node-name>`
- Ensure NAT gateway is enabled for private subnet internet access