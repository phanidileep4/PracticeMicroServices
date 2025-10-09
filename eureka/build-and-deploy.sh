#!/bin/bash

# Complete deployment script for homefood microservices
# This script builds, pushes, and deploys all services to Google Cloud Run

set -e

PROJECT_ID="homefood-436801"
REGION="us-central1"
REGISTRY="gcr.io"

echo "🚀 Starting complete deployment for homefood microservices (Project: $PROJECT_ID)"
echo "=============================================================================="

# Get the parent directory (PracticeMicroServices)
PARENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "Working from directory: $PARENT_DIR"

# Check prerequisites
echo "📋 Checking prerequisites..."

if ! command -v gcloud &> /dev/null; then
    echo "❌ Error: gcloud CLI is not installed. Please install Google Cloud SDK first."
    exit 1
fi

if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    echo "❌ Error: Not authenticated with gcloud. Please run 'gcloud auth login'"
    exit 1
fi

if ! command -v docker &> /dev/null; then
    echo "❌ Error: Docker is not installed or not running."
    exit 1
fi

echo "✅ All prerequisites met!"

# Set project and enable APIs
echo "🔧 Setting up Google Cloud project..."
gcloud config set project $PROJECT_ID

echo "🔌 Enabling required APIs..."
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable cloudbuild.googleapis.com

echo "🔑 Configuring Docker authentication..."
gcloud auth configure-docker

# Build JAR files
echo "🏗️  Building all microservices..."

echo "📦 Building Eureka Server..."
cd "$PARENT_DIR/eureka" && mvn clean package -DskipTests -q

echo "📦 Building User Service..."
cd "$PARENT_DIR/userinfo" && mvn clean package -DskipTests -q

echo "📦 Building Chef Service..."
cd "$PARENT_DIR/chefListing" && mvn clean package -DskipTests -q

echo "📦 Building Food Catalogue Service..."
cd "$PARENT_DIR/foodcatalogue" && mvn clean package -DskipTests -q

echo "📦 Building Order Service..."
cd "$PARENT_DIR/order" && mvn clean package -DskipTests -q

# Build and push Docker images
echo "🐳 Building and pushing Docker images..."

# Eureka Server
cd "$PARENT_DIR/eureka"
docker build --platform linux/amd64 -t $REGISTRY/$PROJECT_ID/eureka:latest . --quiet
echo "🚢 Pushing eureka..."
docker push $REGISTRY/$PROJECT_ID/eureka:latest

# User Service
cd "$PARENT_DIR/userinfo"
docker build --platform linux/amd64 -t $REGISTRY/$PROJECT_ID/userinfo:latest . --quiet
echo "🚢 Pushing userinfo..."
docker push $REGISTRY/$PROJECT_ID/userinfo:latest

# Chef Service
cd "$PARENT_DIR/chefListing"
docker build --platform linux/amd64 -t $REGISTRY/$PROJECT_ID/cheflisting:latest . --quiet
echo "🚢 Pushing cheflisting..."
docker push $REGISTRY/$PROJECT_ID/cheflisting:latest

# Food Catalogue Service
cd "$PARENT_DIR/foodcatalogue"
docker build --platform linux/amd64 -t $REGISTRY/$PROJECT_ID/foodcatalogue:latest . --quiet
echo "🚢 Pushing foodcatalogue..."
docker push $REGISTRY/$PROJECT_ID/foodcatalogue:latest

# Order Service
cd "$PARENT_DIR/order"
docker build --platform linux/amd64 -t $REGISTRY/$PROJECT_ID/order:latest . --quiet
echo "🚢 Pushing order..."
docker push $REGISTRY/$PROJECT_ID/order:latest

echo "✅ All images built and pushed successfully!"

# Deploy services in correct order
echo "🌐 Deploying services to Google Cloud Run..."

# Deploy Eureka Server first
echo "🔍 Deploying Eureka Server..."
EUREKA_URL=$(gcloud run deploy eureka-service \
  --image $REGISTRY/$PROJECT_ID/eureka:latest \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --memory 2Gi \
  --cpu 2 \
  --timeout 900 \
  --max-instances 3 \
  --set-env-vars SPRING_PROFILES_ACTIVE=cloud \
  --quiet \
  --format="value(status.url)")

echo "✅ Eureka Server deployed at: $EUREKA_URL"

# Wait for Eureka to be ready
echo "⏳ Waiting for Eureka Server to be ready..."
sleep 30

# Deploy User Service
echo "👤 Deploying User Service..."
gcloud run deploy userinfo-service \
  --image $REGISTRY/$PROJECT_ID/userinfo:latest \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --memory 1Gi \
  --cpu 1 \
  --timeout 600 \
  --max-instances 3 \
  --set-env-vars EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=$EUREKA_URL/eureka/,SPRING_PROFILES_ACTIVE=cloud \
  --quiet

# Deploy Chef Service
echo "👨‍🍳 Deploying Chef Service..."
gcloud run deploy cheflisting-service \
  --image $REGISTRY/$PROJECT_ID/cheflisting:latest \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --memory 1Gi \
  --cpu 1 \
  --timeout 600 \
  --max-instances 3 \
  --set-env-vars EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=$EUREKA_URL/eureka/,SPRING_PROFILES_ACTIVE=cloud \
  --quiet

# Deploy Food Catalogue Service
echo "🍽️ Deploying Food Catalogue Service..."
gcloud run deploy foodcatalogue-service \
  --image $REGISTRY/$PROJECT_ID/foodcatalogue:latest \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --memory 1Gi \
  --cpu 1 \
  --timeout 600 \
  --max-instances 3 \
  --set-env-vars EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=$EUREKA_URL/eureka/,SPRING_PROFILES_ACTIVE=cloud \
  --quiet

# Deploy Order Service
echo "📋 Deploying Order Service..."
gcloud run deploy order-service \
  --image $REGISTRY/$PROJECT_ID/order:latest \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --memory 1Gi \
  --cpu 1 \
  --timeout 600 \
  --max-instances 3 \
  --set-env-vars EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=$EUREKA_URL/eureka/,SPRING_PROFILES_ACTIVE=cloud \
  --quiet

echo ""
echo "🎉 DEPLOYMENT COMPLETE! 🎉"
echo "=============================================================================="
echo ""
echo "📋 Service URLs:"
echo "🔍 Eureka Server: $EUREKA_URL"
echo "👤 User Service: $(gcloud run services describe userinfo-service --region=$REGION --format='value(status.url)' 2>/dev/null)"
echo "👨‍🍳 Chef Service: $(gcloud run services describe cheflisting-service --region=$REGION --format='value(status.url)' 2>/dev/null)"
echo "🍽️ Food Catalogue: $(gcloud run services describe foodcatalogue-service --region=$REGION --format='value(status.url)' 2>/dev/null)"
echo "📋 Order Service: $(gcloud run services describe order-service --region=$REGION --format='value(status.url)' 2>/dev/null)"

echo ""
echo "🎯 Next steps:"
echo "  • Open Eureka Dashboard: $EUREKA_URL"
echo "  • Monitor services: ./monitor-services.sh"
echo "  • Check logs in Google Cloud Console"
echo ""
echo "💡 Your homefood microservices are now running in the cloud!"