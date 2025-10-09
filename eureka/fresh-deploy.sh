#!/bin/bash

# Fresh deployment script with minimal Eureka configuration
PROJECT_ID="homefood-436801"
REGION="us-central1"

echo "🔄 Creating fresh Eureka deployment with minimal configuration..."

# Delete existing service to start completely fresh
echo "🗑️ Removing existing service..."
gcloud run services delete eureka-service --region=$REGION --project=$PROJECT_ID --quiet

# Build with minimal config
echo "🏗️ Building with minimal configuration..."
mvn clean package -DskipTests

# Build and push new image
echo "🐳 Building fresh Docker image..."
docker build --platform linux/amd64 -t gcr.io/$PROJECT_ID/eureka:fresh .
docker push gcr.io/$PROJECT_ID/eureka:fresh

# Deploy completely fresh service
echo "🚀 Deploying fresh Eureka service..."
gcloud run deploy eureka-service \
    --image gcr.io/$PROJECT_ID/eureka:fresh \
    --platform managed \
    --region $REGION \
    --allow-unauthenticated \
    --memory 2Gi \
    --cpu 2 \
    --timeout 900 \
    --max-instances 1 \
    --set-env-vars SPRING_PROFILES_ACTIVE=cloud \
    --project $PROJECT_ID

# Wait for deployment
echo "⏳ Waiting for service to be ready..."
sleep 90

# Get new URL
NEW_URL=$(gcloud run services describe eureka-service --region=$REGION --project=$PROJECT_ID --format='value(status.url)')

echo "🔍 Testing new deployment..."
echo "New URL: $NEW_URL"

# Test various endpoints
echo "Testing main endpoint..."
curl -I "$NEW_URL" 2>/dev/null | head -n 1

echo "Testing health endpoint..."
curl -I "$NEW_URL/actuator/health" 2>/dev/null | head -n 1

echo "Testing eureka endpoint..."
curl -I "$NEW_URL/eureka" 2>/dev/null | head -n 1

echo "✅ Fresh deployment complete!"
echo "🎯 New Eureka URL: $NEW_URL"