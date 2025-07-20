# AWS Configuration
aws_region = "us-east-1"

# Project Configuration
project_name = "rails-app"
environment  = "dev"

# Network Configuration
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

# # Database Configuration
# db_username = "railsuser"
# db_password = "xxxxxxxxxx"  #pass environment variables

# ECR Configuration
ecr_repository_name = "rails-app"
app_image_tag       = "latest"

# EKS Configuration
node_instance_type = "t3.medium"
desired_capacity   = 2
max_capacity       = 4
min_capacity       = 1
