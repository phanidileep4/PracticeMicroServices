#!/bin/bash

# Ultra-optimized Eureka deployment for Cloud Run
PROJECT_ID="homefood-436801"
REGION="us-central1"
REGISTRY="gcr.io"

echo "🚀 Deploying optimized Eureka with minimal startup time..."

# Deploy with maximum resources and extended timeout
gcloud run deploy eureka-service \
  --image $REGISTRY/$PROJECT_ID/eureka:latest \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --memory 4Gi \
  --cpu 4 \
  --timeout 1200 \
  --max-instances 1 \
  --min-instances 0 \
  --concurrency 80 \
  --set-env-vars SPRING_PROFILES_ACTIVE=cloud,JAVA_OPTS="-Xmx3g -Xms1g -XX:+UseG1GC -XX:MaxGCPauseMillis=200" \
  --cpu-boost \
  --execution-environment gen2

echo "Checking deployment status..."
sleep 60

# Get the service URL
EUREKA_URL=$(gcloud run services describe eureka-service --region=$REGION --format='value(status.url)')

if [ ! -z "$EUREKA_URL" ]; then
    echo "✅ Eureka deployed at: $EUREKA_URL"
    echo "🔍 Testing health endpoint..."
    
    # Wait for service to be ready
    for i in {1..10}; do
        health_response=$(curl -s -o /dev/null -w "%{http_code}" "$EUREKA_URL/actuator/health" 2>/dev/null || echo "000")
        if [ "$health_response" = "200" ]; then
            echo "✅ Eureka is healthy and ready!"
            break
        else
            echo "⏳ Waiting for Eureka to be ready... (attempt $i/10)"
            sleep 30
        fi
    done
    
    echo "🎯 Eureka Dashboard: $EUREKA_URL"
else
    echo "❌ Failed to get Eureka URL. Checking logs..."
    gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=eureka-service" --limit=20 --format="value(timestamp,severity,textPayload)" --project=$PROJECT_ID
fi