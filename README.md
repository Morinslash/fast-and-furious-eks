# **Fast and Furious EKS Terraform Repository**

## **Purpose**
This repository is designed to deploy AWS VPC infrastructure as a foundation for EKS clusters for testing and experimentation purposes. Currently, the repository implements:
- **Private VPC** creation with configurable CIDR blocks
- **Private subnet** deployment in a single availability zone
- **Automatic owner tagging** based on AWS CLI user identity
- **No NAT gateway** for cost optimization in lab environments

**Note**: The EKS cluster deployment is planned but not yet implemented. The `/eks/` module directory contains placeholder files.

---

## **Current Infrastructure**

### **Implemented Components**
- ✅ **VPC Module**: Creates private VPC using terraform-aws-modules/vpc/aws (~> 5.0)
- ✅ **Private Subnet**: Single private subnet deployment
- ✅ **DNS Configuration**: Enables DNS support and hostnames
- ✅ **Resource Tagging**: Automatic owner identification and tagging
- ❌ **EKS Cluster**: Not yet implemented (placeholder files exist)

### **Architecture**
- **VPC**: Configurable CIDR block (default: 10.0.0.0/16)
- **Private Subnet**: Single subnet (default: 10.0.1.0/24)
- **Availability Zone**: Single AZ deployment (default: eu-west-1a)
- **NAT Gateway**: Disabled for cost optimization
- **Internet Gateway**: Not configured (private-only setup)

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
   ```

---

## **Resource Tagging**

The infrastructure automatically applies tags to all resources:
- **ManagedBy**: "terraform"
- **Owner**: Extracted from AWS CLI user identity
- **ResourceType**: Applied per module (e.g., "network" for VPC resources)

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
   Applies the plan and creates the VPC infrastructure.
   ```bash
   terraform apply
   ```

4. **Destroy Infrastructure:**
   Destroys all resources defined by Terraform.
   ```bash
   terraform destroy
   ```

### **Additional Commands**

5. **Validate the Configuration:**
   Ensures your configuration is syntactically valid.
   ```bash
   terraform validate
   ```

6. **Format Terraform Files:**
   Formats your Terraform files to the standard style.
   ```bash
   terraform fmt
   ```

---

## **Outputs**

After successful deployment, Terraform provides the following outputs:
- **current_account_id**: AWS account ID of the CLI profile in use
- **vpc_id**: ID of the created VPC
- **private_subnet_ids**: IDs of the private subnets created

---

## **Development Status**

### **Completed**
- ✅ VPC infrastructure with terraform-aws-modules/vpc/aws
- ✅ Private subnet configuration
- ✅ Automatic resource tagging
- ✅ AWS provider configuration with profile support

### **Planned/In Progress**
- ❌ EKS cluster module implementation
- ❌ Node group configuration
- ❌ kubectl access configuration
- ❌ Port forwarding setup documentation

### **Module Structure**
```
├── main.tf                    # Root configuration with VPC module
├── variables.tf               # Global variables
├── outputs.tf                 # Root outputs
├── provider.tf               # AWS provider configuration
├── terraform.tfvars.example  # Example variables
├── vpc/                      # VPC module (implemented)
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── eks/                      # EKS module (placeholder)
    ├── main.tf               # Empty
    ├── variables.tf          # Empty
    ├── outputs.tf            # Empty
    └── locals.tf             # Empty
```