# **Fast and Furious EKS Terraform Repository**

## **Purpose**
This repository is designed to deploy temporary AWS EKS clusters for testing and experimentation purposes. Each cluster is created in a **private VPC** and is accessible only by the machine running Terraform (using `kubectl` or port forwarding). The setup ensures:
- No public access to infrastructure.
- Fully configurable deployments using local AWS CLI credentials.
- No remote Terraform state management, making this ideal for temporary labs.

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
   sso_region = us-east-1
   sso_account_id = 123456789012
   sso_role_name = YourRoleName
   region = us-east-1
   ```
2. After configuration, log in using `aws sso login --profile your-profile-name`.

---

## **Variable Management**

### **Cloning and Providing Variables**
1. Clone the example variables file for customization:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
2. Edit `terraform.tfvars` to provide your specific AWS credentials and region:
   ```hcl
   profile = "your-aws-profile"
   region = "us-east-1"
   ```

This ensures Terraform uses the correct AWS CLI profile and region for deploying resources.

---

## **State Management**
- Terraform uses **local state** for managing the infrastructure.
- State files, such as `terraform.tfstate` and `.terraform/` directories, are ignored in version control through `.gitignore`.

Because this project is for temporary lab environments, no remote state management is configured (e.g., S3 and DynamoDB). For production usage, consider adding a remote backend.

---

## **Basic Terraform Commands**

Here are the most commonly used Terraform commands for this repository:

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
   Applies the plan and creates the desired resources.
   ```bash
   terraform apply
   ```

4. **Destroy Infrastructure:**
   Destroys all resources defined by Terraform.
   ```bash
   terraform destroy
   ```

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