# Terraform Setup for AWS Backend and EC2 Instance

This project demonstrates how to use Terraform to configure AWS resources, including an S3 bucket with versioning and server-side encryption, a DynamoDB table for state locking, and an EC2 instance to verify the Terraform setup.

## Prerequisites

1. **Terraform Installed**: Ensure Terraform is installed on your local machine. You can download it from [here](https://www.terraform.io/downloads).
2. **AWS CLI Configured**: Ensure the AWS CLI is installed and configured with the appropriate credentials and region.

## Files Overview

### 'backend.tf'
- Creates an S3 bucket for Terraform state storage.
- Configures server-side encryption and versioning for the S3 bucket.
- Creates a DynamoDB table for Terraform state locking.

### 'main.tf'
- Configures Terraform backend to use the S3 bucket and DynamoDB table.
- Provisions an EC2 instance as a test resource.

## Step-by-Step Instructions

### Step 1: Clone the Repository
Clone this repository to your local machine:
'''bash
git clone <repository-url>
cd <repository-directory>
'''

### Step 2: Initialize Terraform Backend

1. Navigate to the project directory containing the 'backend.tf' and 'main.tf' files.
2. Run the following command to initialize Terraform and configure the backend:
   '''bash
   terraform init
   '''
   This command sets up the backend configuration to use the S3 bucket and DynamoDB table for state management.

### Step 3: Plan the Infrastructure
Generate an execution plan to verify the resources to be created:
'''bash
terraform plan
'''

### Step 4: Apply the Configuration
Deploy the infrastructure:
'''bash
terraform apply
'''
When prompted, type 'yes' to confirm the deployment.

### Step 5: Verify S3 Bucket Versioning

1. After the EC2 instance is created, check the S3 bucket ('kiosk-tf-s3-bucket') in the AWS Management Console.
2. Navigate to the 'terraform/state/terraform.tfstate' file and observe the version history to verify that versioning is enabled.

### Step 6: Clean Up Resources
To destroy the resources and avoid incurring charges, run:
'''bash
terraform destroy
'''
When prompted, type 'yes' to confirm the destruction.

## Key Details

### Backend Configuration
- **S3 Bucket**: Stores the Terraform state file with versioning and server-side encryption enabled.
- **DynamoDB Table**: Manages state locking to ensure consistent operations in a shared environment.

### EC2 Instance
- An Amazon Linux 2 instance ('t2.micro') is created as a sample resource to verify the backend configuration.
- Tags are applied to identify the instance easily.

## Notes
- Update the S3 bucket name in `backend.tf` and 'main.tf' to ensure it is globally unique.
- Ensure your AWS credentials have sufficient permissions to create the required resources.

---

This setup serves as a foundational example of managing Terraform state files securely and deploying AWS resources effectively. You can extend it to include more complex infrastructure configurations.
