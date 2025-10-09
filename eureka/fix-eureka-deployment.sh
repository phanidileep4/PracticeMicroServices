#!/bin/bash

# Quick fix script to rebuild and deploy Eureka with correct architecture and startup config

PROJECT_ID="homefood-436801"
REGION="us-central1"
REGISTRY="gcr.io"

echo "🔧 Quick fix: Rebuilding Eureka with correct architecture and startup config..."

# Navigate to parent directory
PARENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Rebuild Eureka with correct platform
echo "🐳 Building Eureka for linux/amd64..."
cd "$PARENT_DIR/eureka"
docker build --platform linux/amd64 -t $REGISTRY/$PROJECT_ID/eureka:latest .

echo "🚢 Pushing corrected Eureka image..."
docker push $REGISTRY/$PROJECT_ID/eureka:latest

echo "🔍 Deploying Eureka Server with extended timeout and health checks..."
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
  --format="value(status.url)")

if [ $? -eq 0 ]; then
    echo "✅ Eureka Server successfully deployed at: $EUREKA_URL"
    echo "🎯 Now you can run the full deployment script to deploy the remaining services"
    
    # Test the deployment
    echo "🔍 Testing Eureka Server health..."
    sleep 30
    health_response=$(curl -s -o /dev/null -w "%{http_code}" "$EUREKA_URL")
    if [ "$health_response" = "200" ]; then
        echo "✅ Eureka Server is responding correctly!"
    else
        echo "⚠️ Eureka Server might still be starting up. Check the URL: $EUREKA_URL"
    fi
else
    echo "❌ Deployment still failed. Checking logs..."
    gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=eureka-service" --limit=20 --format="value(timestamp,severity,textPayload)"
fi