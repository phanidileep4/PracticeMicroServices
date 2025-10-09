#!/bin/bash

# Cloud Migration Script for Practice Microservices
# This script builds Docker images and pushes them to Google Container Registry

set -e

# Configuration
PROJECT_ID=${1:-"homefood-436801"}
REGION="us-central1"
REGISTRY="gcr.io"

echo "Starting cloud migration for project: $PROJECT_ID"

# Check if gcloud is installed and authenticated
if ! command -v gcloud &> /dev/null; then
    echo "Error: gcloud CLI is not installed. Please install Google Cloud SDK first."
    exit 1
fi

# Check if user is authenticated
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    echo "Error: Not authenticated with gcloud. Please run 'gcloud auth login'"
    exit 1
fi

# Set the project
gcloud config set project $PROJECT_ID

# Enable required APIs
echo "Enabling required Google Cloud APIs..."
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable cloudbuild.googleapis.com

# Configure Docker to use gcloud as a credential helper
gcloud auth configure-docker

echo "Building and pushing microservices to Google Container Registry..."

# Build and push Eureka Server
echo "Building Eureka Server..."
cd eureka
mvn clean package -DskipTests
docker build -t $REGISTRY/$PROJECT_ID/eureka:latest .
docker push $REGISTRY/$PROJECT_ID/eureka:latest

# Build and push User Service
echo "Building User Service..."
cd ../userinfo
mvn clean package -DskipTests
docker build -t $REGISTRY/$PROJECT_ID/userinfo:latest .
docker push $REGISTRY/$PROJECT_ID/userinfo:latest

# Build and push Chef Service
echo "Building Chef Service..."
cd ../chefListing
mvn clean package -DskipTests
docker build -t $REGISTRY/$PROJECT_ID/cheflisting:latest .
docker push $REGISTRY/$PROJECT_ID/cheflisting:latest

# Build and push Food Catalogue Service
echo "Building Food Catalogue Service..."
cd ../foodcatalogue
mvn clean package -DskipTests
docker build -t $REGISTRY/$PROJECT_ID/foodcatalogue:latest .
docker push $REGISTRY/$PROJECT_ID/foodcatalogue:latest

# Build and push Order Service
echo "Building Order Service..."
cd ../order
mvn clean package -DskipTests
docker build -t $REGISTRY/$PROJECT_ID/order:latest .
docker push $REGISTRY/$PROJECT_ID/order:latest

echo "All images successfully pushed to Google Container Registry!"
echo "Next, run deploy-to-cloudrun.sh to deploy the services"