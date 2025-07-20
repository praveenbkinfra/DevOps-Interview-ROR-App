#!/bin/bash

# Configuration
AWS_REGION="us-east-1"
ECR_REPOSITORY_NAME="rails-app"
IMAGE_TAG="latest"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get AWS Account ID
echo -e "${YELLOW}Getting AWS Account ID...${NC}"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to get AWS Account ID. Check your AWS CLI configuration.${NC}"
    exit 1
fi

echo -e "${GREEN}AWS Account ID: ${AWS_ACCOUNT_ID}${NC}"

# ECR Repository URL
ECR_REPO_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY_NAME}"

echo -e "${YELLOW}Building and pushing Docker image to ECR...${NC}"
echo -e "${YELLOW}ECR Repository: ${ECR_REPO_URL}${NC}"

# Check if ECR repository exists, create if it doesn't
echo -e "${YELLOW}Checking if ECR repository exists...${NC}"
aws ecr describe-repositories --repository-names ${ECR_REPOSITORY_NAME} --region ${AWS_REGION} >/dev/null 2>&1

if [ $? -ne 0 ]; then
    echo -e "${YELLOW}ECR repository doesn't exist. Creating...${NC}"
    aws ecr create-repository --repository-name ${ECR_REPOSITORY_NAME} --region ${AWS_REGION}
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}ECR repository created successfully${NC}"
    else
        echo -e "${RED}Failed to create ECR repository${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}ECR repository already exists${NC}"
fi

# Login to ECR
echo -e "${YELLOW}Logging in to ECR...${NC}"
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO_URL}

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to login to ECR${NC}"
    exit 1
fi

echo -e "${GREEN}Successfully logged in to ECR${NC}"

# Build Docker image for Rails app
echo -e "${YELLOW}Building Rails app Docker image...${NC}"
docker build -f docker/app/Dockerfile -t ${ECR_REPOSITORY_NAME}:${IMAGE_TAG} .

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to build Docker image${NC}"
    exit 1
fi

echo -e "${GREEN}Docker image built successfully${NC}"

# Tag image for ECR
echo -e "${YELLOW}Tagging image for ECR...${NC}"
docker tag ${ECR_REPOSITORY_NAME}:${IMAGE_TAG} ${ECR_REPO_URL}:${IMAGE_TAG}

# Push image to ECR
echo -e "${YELLOW}Pushing image to ECR...${NC}"
docker push ${ECR_REPO_URL}:${IMAGE_TAG}

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to push image to ECR${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Image successfully pushed to: ${ECR_REPO_URL}:${IMAGE_TAG}${NC}"

# Get image URI for Kubernetes deployment
echo -e "${YELLOW}📋 Use this image URI in your Kubernetes deployment:${NC}"
echo -e "${GREEN}${ECR_REPO_URL}:${IMAGE_TAG}${NC}"

# Optional: Get image digest
IMAGE_DIGEST=$(aws ecr describe-images --repository-name ${ECR_REPOSITORY_NAME} --region ${AWS_REGION} --query 'imageDetails[0].imageDigest' --output text)
echo -e "${YELLOW}📋 Image digest: ${IMAGE_DIGEST}${NC}"
