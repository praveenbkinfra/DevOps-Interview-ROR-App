# Ruby on Rails Application - AWS EKS DevOps Infrastructure

## 🎯 Project Overview

This repository demonstrates a complete DevOps infrastructure deployment for a Ruby on Rails application using AWS EKS, implemented with Terraform Infrastructure as Code and Kubernetes best practices.

### 🏗️ Infrastructure Components

- **Container Orchestration**: Amazon EKS (Kubernetes 1.28)
- **Infrastructure as Code**: Terraform with modular architecture
- **Database**: Amazon RDS PostgreSQL with Multi-AZ
- **Storage**: Amazon S3 with IAM role-based authentication
- **Load Balancing**: AWS Network Load Balancer
- **Container Registry**: Amazon ECR
- **Security**: Private subnets, Security Groups, IRSA


1. Clone the repository

cd DevOps-Interview-ROR-App

2. Setup infrastructure
cd infrastructure

terraform.tfvars

Edit terraform.tfvars with your values

3. Deploy AWS infrastructure

terraform init
terraform plan
terraform apply

4. Configure kubectl

aws eks update-kubeconfig --region us-east-1 --name rails-app-dev-eks

5. Build and push container
./scripts/build-and-push.sh

6. Deploy application
kubectl apply -f k8s-manifests/



## 🏗️ Architecture Highlights

### Security Implementation
- ✅ All application resources in private subnets
- ✅ IAM Roles for Service Accounts (IRSA) for S3 access
- ✅ RDS encryption at rest and in transit
- ✅ Security Groups with least privilege access
- ✅ S3 bucket encryption and access controls

### High Availability Design
- ✅ Multi-AZ deployment across 3 availability zones
- ✅ EKS Auto Scaling Groups with 2-4 nodes
- ✅ Application Load Balancer for traffic distribution
- ✅ RDS Multi-AZ for database failover
- ✅ Kubernetes pod replicas for application resilience

### Scalability Features
- ✅ Kubernetes Horizontal Pod Autoscaler ready
- ✅ EKS Cluster Autoscaler configuration
- ✅ RDS storage auto-scaling
- ✅ Environment-specific configurations

## 📊 Infrastructure Resources

| AWS Service | Resource Type | Purpose | Configuration |
|-------------|---------------|---------|---------------|
| **Amazon EKS** | Kubernetes Cluster | Container orchestration | 2-4 t3.medium nodes |
| **Amazon RDS** | PostgreSQL Database | Application database | db.t3.micro Multi-AZ |
| **Amazon S3** | Object Storage | File and asset storage | Encrypted, versioned |
| **Amazon ECR** | Container Registry | Docker image storage | Lifecycle policies |
| **Amazon VPC** | Virtual Network | Network isolation | 10.0.0.0/16 CIDR |
| **AWS ALB** | Load Balancer | Traffic distribution | Internet-facing NLB |

## 🔧 Configuration Management

### Environment Variables
The application uses Kubernetes secrets for sensitive data:
- `DATABASE_URL`: PostgreSQL connection string
- `S3_BUCKET_NAME`: S3 bucket for file storage
- `SECRET_KEY_BASE`: Rails application secret
- `S3_REGION_NAME`: AWS region for S3 access

use to set environment variables with actual values from Terraform output
export RDS_PASSWORD="SecurePassword123!" 
export RDS_HOSTNAME="rails-app-dev-postgres.XXXXX.us-east-1.rds.amazonaws.com"
export RDS_USERNAME="railsuser"
export RDS_DB_NAME="railsapp"
export RDS_PORT="5432"
export S3_REGION_NAME="us-east-1"


### Terraform Modules
Each infrastructure component is implemented as a reusable Terraform module:
- **VPC Module**: Network infrastructure with public/private subnets
- **EKS Module**: Kubernetes cluster with node groups and OIDC
- **RDS Module**: PostgreSQL database with security groups
- **S3 Module**: Object storage with encryption and policies
- **IAM Module**: Service accounts and roles for IRSA
- **ECR Module**: Container registry with lifecycle policies

## 📋 Deployment Verification

### Health Checks
Verify infrastructure
terraform output

Check Kubernetes resources
kubectl get all -l app=rails-app
